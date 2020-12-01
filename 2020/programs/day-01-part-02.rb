require './day'

class Day1Part2 < Day
  DAY = 1
  PART = 2

  def call
    matching_set.inject(:*)
  end

  private

  def matching_set
    input.each_with_index do |v1, index|
      input[index + 1..-1].each do |v2|
        input[index + 2..-1].each do |v3|
          set = [v1, v2, v3].map(&:to_i)
          return set if set.inject(:+) == 2020
        end
      end
    end
  end
end
