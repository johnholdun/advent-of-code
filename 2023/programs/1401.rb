class Response
  TYPES = {
    '.' => :blank,
    '#' => :square,
    'O' => :round
  }.freeze

  def call(input)
    columns = {}

    input.each_with_index do |line, row|
      line.split('').each_with_index do |char, col|
        columns[col] = columns[col] || []
        columns[col].push(TYPES[char])
      end
    end

    columns.map do |col, items|
      new_items = []
      held_blanks = 0
      weight = 0

      items.each_with_index do |item, index|
        case item
        when :blank
          held_blanks += 1
        when :square
          held_blanks.times { new_items.push(:blank) }
          held_blanks = 0
          new_items.push(:square)
        when :round
          weight += items.size - new_items.size
          new_items.push(:round)
        end
      end

      weight
    end.sum
  end
end
