require './day'

class Day1Part1 < Day
  DAY = 1
  PART = 1

  def call
    pair = []

    input.each_with_index do |value1, index1|
      input.each_with_index do |value2, index2|
        next if index1 == index2
        prospective_pair = [value1, value2].map(&:to_i)
        if prospective_pair.inject(:+) == 2020
          pair = prospective_pair
          break
        end
      end
      break unless pair.size.zero?
    end

    pair.inject(:*)
  end
end
