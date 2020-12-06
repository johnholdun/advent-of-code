require './day'

class Day6Part1 < Day
  DAY = 6
  PART = 1

  def call
    input.join("\n").split(/\n{2,}/).map { |as| as.scan(/[a-z]/).uniq.size }.sum
  end
end
