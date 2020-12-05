require './day'

class Day5Part2 < Day
  DAY = 5
  PART = 2

  def call
    ids = input.map { |t| parse_ticket(t).last }.sort

    (ids.min..ids.max).find do |id|
      !ids.include?(id)
    end
  end

  private

  def chars_to_int(chars)
    chars.split('').map { |c| %w(F L).include?(c) ? '0' : '1' }.join('').to_i(2)
  end

  def parse_ticket(ticket)
    row = chars_to_int(ticket[0, 7])
    column = chars_to_int(ticket[7, 3])

    [row, column, row * 8 + column]
  end
end
