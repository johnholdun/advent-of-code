require './day'

class Day2Part2 < Day
  DAY = 2
  PART = 2

  def call
    input.count do |line|
      _, a, b, char, password = line.match(/^(\d+)-(\d+) ([a-z]): ([a-z]+)$/).to_a
      (password[a.to_i - 1] == char) ^ (password[b.to_i - 1] == char)
    end
  end
end
