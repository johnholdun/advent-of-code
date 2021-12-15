require 'set'

class Grid
  attr_reader :cells

  def initialize(cells)
    @cells = cells
    @lookup = cells.each_with_object({}) { |c, h| h[[c.x, c.y]] = c }

    cells.each_with_index do |cell, index|
      cell.neighbors = neighbors(cell)
      cell.index = index
    end
  end

  def at(x, y)
    lookup[[x, y]]
  end

  def shortest_path(start, goal)
    open_set = [start.index]
    came_from = {}
    risk = Hash.new(99999)
    risk[start.index] = 0
    remaining_risk = Hash.new(99999)
    remaining_risk[start.index] = estimated_remaining_risk(start, goal)

    loop do
      current = open_set.min { |i| risk[i] + estimated_remaining_risk(cells[i], goal) }

      if current == goal.index
        total_path = [cells[current]]
        loop do
          earliest_cell = total_path.first
          prev_cell_index = came_from[earliest_cell.index]
          break unless prev_cell_index
          prev_cell = cells[prev_cell_index]
          break unless prev_cell
          total_path.unshift(prev_cell)
          if prev_cell == start
            return total_path.map(&:risk).inject(:+) - start.risk
          end
        end
      end

      open_set -= [current]
      cells[current].neighbors.each do |neighbor|
        tentative_risk = risk[current] + neighbor.risk
        if tentative_risk < risk[neighbor.index]
          came_from[neighbor.index] = current
          risk[neighbor.index] = tentative_risk
          remaining_risk[neighbor.index] = tentative_risk + estimated_remaining_risk(neighbor, goal)
          open_set.push(neighbor.index) unless open_set.include?(neighbor.index)
        end
      end

      break if open_set.size.zero?
    end

    raise 'uh oh'
  end

  private

  attr_reader :lookup

  def neighbors(cell)
    (-1..1).flat_map do |dx|
      (-1..1).map do |dy|
        next if dx.abs == 1 && dy.abs == 1
        lookup[[cell.x + dx, cell.y + dy]]
      end
    end.compact
  end

  def estimated_remaining_risk(pos, goal)
    (goal.x - pos.x).abs + (goal.y - pos.y).abs
  end
end

class Cell
  attr_reader :risk, :x, :y
  attr_accessor :neighbors, :index

  def initialize(risk, x, y)
    @risk = risk
    @x = x
    @y = y
    @neighbors = []
  end

  def id
    "#{x}/#{y}"
  end
end

class Response
  def call(input)
    parsed_lines = input.map { |line| line.split('').map(&:to_i) }
    parsed_lines.map! do |line|
      (line * 5).each_with_index.map do |risk, index|
        ((((risk - 1) + (index / line.size.to_f)) % 9) + 1).to_i
      end
    end
    extended_lines =
      (parsed_lines * 5).each_with_index.map do |line, index|
        line.map do |risk|
          ((((risk - 1) + (index / input.size.to_f)) % 9) + 1).to_i
        end
      end

    grid =
      Grid.new(
        extended_lines.each_with_index.flat_map do |risks, y|
          risks.each_with_index.map do |risk, x|
            Cell.new(risk, x, y)
          end
        end
      )

    grid.shortest_path \
      grid.at(0, 0),
      grid.at(grid.cells.map(&:x).max, grid.cells.map(&:y).max)
  end
end
