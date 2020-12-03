require './day'

class Day3Part1 < Day
  DAY = 3
  PART = 1

  SLOPE_RIGHT = 3

  def call
    input.each_with_index.count do |line, index|
      line[(index * SLOPE_RIGHT) % line.size] == '#'
    end
  end
end
