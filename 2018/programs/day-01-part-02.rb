require './day'

class Day1Part2 < Day
  DAY = 1
  PART = 2

  def call
    seen = [0]
    index = 0
    value = 0

    changes = input.map { |i| i.sub(/^\+/, '').to_i }

    begin
      value += changes[index]
      break if seen.include?(value)
      seen.push(value)
      index = (index + 1) % changes.size
    end while true

    value
  end
end
