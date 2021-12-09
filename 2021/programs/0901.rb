class Grid
  attr_reader :cells

  def initialize(cells)
    @cells = cells
    cells.each do |cell|
      cell.neighbors = neighbors(cell)
    end
  end

  def minima
    cells.select(&:minimum?)
  end

  private

  def neighbors(cell)
    [[0, -1], [1, 0], [0, 1], [-1, 0]].map do |(dx, dy)|
      cells.find { |c| c.x == cell.x + dx && c.y == cell.y + dy }
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

    grid.minima.map(&:risk_level).sum
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
