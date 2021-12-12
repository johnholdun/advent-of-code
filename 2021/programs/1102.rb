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

  def draw
    cells.map(&:y).sort.uniq.each do |y|
      cells.map(&:x).sort.uniq.each do |x|
        print lookup[[x, y]].energy
      end
      puts
    end
  end

  def step!
    cells.each(&:increment!).each(&:reset!).count { |c| c.energy.zero? }
  end

  private

  attr_reader :lookup

  def neighbors(cell)
    (-1..1).flat_map do |dx|
      (-1..1).map do |dy|
        lookup[[cell.x + dx, cell.y + dy]]
      end
    end.compact
  end
end

class Cell
  attr_reader :energy, :x, :y
  attr_accessor :neighbors

  def initialize(energy, x, y)
    @energy = energy
    @x = x
    @y = y
    @neighbors = []
  end

  def id
    "#{x}/#{y}"
  end

  def increment!
    @energy += 1
    flash! if energy == 10
  end

  def flash!
    neighbors.each(&:increment!)
  end

  def flashing?
    @energy == 10
  end

  def flashed?
    @energy > 9
  end

  def reset!
    @energy = 0 if energy > 9
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

    n = 1
    loop do
      return n if grid.step! == 100
      n += 1
    end
  end
end
