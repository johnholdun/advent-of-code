require './day'

class Day5Part1 < Day
  DAY = 5
  PART = 1

  def call
    input.map { |t| parse_ticket(t).last }.max
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
