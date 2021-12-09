require 'set'

class Grid
  attr_reader :cells

  def initialize(cells)
    @cells = cells
    @lookup = cells.each_with_object({}) { |c, h| h[[c.x, c.y]] = c }

    cells.each do |cell|
      cell.neighbors = neighbors(cell)
    end
  end

  def minima
    cells.select(&:minimum?)
  end

  def basins
    return @basins if defined?(@basins)
    @basins = []
    found = []
    cells.each do |cell|
      next if cell.height == 9
      next if found.include?(cell.id)
      basin = Set.new([cell])
      basin_size = 1
      loop do
        basin += basin.flat_map(&:neighbors).reject { |c| c.height == 9 }
        break if basin.size == basin_size
        basin_size = basin.size
      end
      @basins.push(basin.size)
      found += basin.map(&:id)
    end
    @basins
  end

  private

  attr_reader :lookup

  def neighbors(cell)
    [[0, -1], [1, 0], [0, 1], [-1, 0]].map do |(dx, dy)|
      lookup[[cell.x + dx, cell.y + dy]]
    end.compact
  end
end

class Cell
  attr_reader :height, :x, :y
  attr_accessor :neighbors

  def initialize(height, x, y)
    @height = height
    @x = x
    @y = y
    @neighbors = []
  end

  def id
    "#{x}/#{y}"
  end

  def minimum?
    neighbors.all? { |c| c.height > height }
  end

  def risk_level
    height + 1
  end
end

class Response
  def call(input)
    grid =
      Grid.new(
        input.each_with_index.flat_map do |line, y|
          line.split('').each_with_index.map do |char, x|
            Cell.new(char.to_i, x, y)
          end
        end
      )

    grid.basins.sort.reverse.take(3).inject(:*)
  end

  private

  def neighbors
  end

  def minimum?(grid, x, y)
    [-1, 0, 1].each do |dx|
      [-1, 0, 1].each do |dy|
        next if dx.abs == 1 && dy.abs == 1
        next if y + dy < 0 || x + dx < 0
        next if y + dy >= grid.size || x + dx >= grid.first.size
        next unless grid[y + dy]
        next unless grid[y + dy][x + dx]
        return false if grid[y + dy][x + dx] < grid[y][x]
      end
    end

    true
  end
end
