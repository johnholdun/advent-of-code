require './day'

class Day5Part2 < Day
  DAY = 5
  PART = 2

  def call
    units = input[0].split('')
    units
      .map(&:downcase)
      .uniq
      .map { |type| evaluate(units.reject { |u| u.downcase == type }) }
      .min
  end

  private

  def evaluate(units)
    begin
      new_units = iterate(units)
      break if new_units.size == units.size
      units = new_units
    end while true

    units.size
  end

  def iterate(units)
    index = 0
    removals = []
    while index < units.size - 1
      a = units[index]
      b = units[index + 1]
      if a.downcase == b.downcase && a != b
        removals += [index, index + 1]
        index += 2
      else
        index += 1
      end
    end
    units
      .each_with_index
      .reject { |_, index| removals.include?(index) }
      .map(&:first)
  end
end
