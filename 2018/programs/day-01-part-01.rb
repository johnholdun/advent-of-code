require './day'

class Day1Part1 < Day
  DAY = 1
  PART = 1

  def call
    input.inject(0) do |value, change|
      value + change.sub(/^\+/, '').to_i
    end
  end
end
