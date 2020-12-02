require './day'

class Day2Part1 < Day
  DAY = 2
  PART = 1

  def call
    input.count do |line|
      _, min, max, char, password = line.match(/^(\d+)-(\d+) ([a-z]): ([a-z]+)$/).to_a
      (min.to_i..max.to_i).include?(password.count(char))
    end
  end
end
