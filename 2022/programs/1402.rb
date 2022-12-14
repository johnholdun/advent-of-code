require 'set'

class Response
  SOURCE = [500, 0].freeze

  def call(input)
    # a block can be a unit of wall or a settled grain of sand
    @blocks = Set.new

    input.each do |line|
      line.split(' -> ').map { |x| x.split(',').map(&:to_i) }.each_cons(2) do |(x1, y1), (x2, y2)|
        if x1 == x2
          a, b = [y1, y2].sort
          (a..b).each do |y|
            blocks.add([x1, y])
          end
        elsif y1 == y2
          a, b = [x1, x2].sort
          (a..b).each do |x|
            blocks.add([x, y1])
          end
        else
          raise 'uhhh'
        end
      end
    end

    wall_count = blocks.size
    @lowest = blocks.map(&:last).max + 2
    x, y = SOURCE

    loop do
      if !blocked?(x, y + 1)
        y += 1
      elsif !blocked?(x - 1, y + 1)
        x -= 1
        y += 1
      elsif !blocked?(x + 1, y + 1)
        x += 1
        y += 1
      else
        blocks.add([x, y])
        break if [x, y] == SOURCE
        x, y = SOURCE
      end
    end

    blocks.size - wall_count
  end

  private

  attr_reader :blocks

  def blocked?(x, y)
    return true if y == @lowest
    blocks.include?([x, y])
  end
end
