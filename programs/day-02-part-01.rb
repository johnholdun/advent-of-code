require './day'

class Day2Part1 < Day
  DAY = 2
  PART = 1

  def call
    exactly_two = 0
    exactly_three = 0

    input.each do |id|
      letters = id.split('')
      counts = letters.sort.uniq.map { |l| letters.select { |l2| l == l2 }.size }
      exactly_two += 1 if counts.include?(2)
      exactly_three += 1 if counts.include?(3)
    end

    exactly_two * exactly_three
  end
end
