require './day'

class Day3Part2 < Day
  DAY = 3
  PART = 2

  def call
    factors =
      [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]].map do |(run, rise)|
        input.each_with_index.count do |line, index|
          next if index % rise != 0
          line[(index / rise * run) % line.size] == '#'
        end
      end

    factors.inject(:*)
  end
end
