class Response
  def call(rows)
    symbols = []
    numbers = []

    rows.each_with_index do |chars_string, row|
      chars = chars_string.split('')
      chars.each_with_index do |char, column|
        next if char == '.'

        if char =~ /[0-9]/ && (column == 0 || chars[column - 1] !~ /[0-9]/)
          number = []
          n = column
          while n < chars.size
            break if chars[n] !~ /[0-9]/
            number.push(chars[n])
            n += 1
          end

          numbers.push({ number: number.join.to_i, position: [column, row], length: number.size })
        else
          symbols.push("#{column},#{row}")
        end
      end
    end

    numbers
      .select do |record|
        number = record[:number]
        position = record[:position]
        length = record[:length]

        (-1..length).to_a.any? do |delta_column|
          (-1..1).to_a.any? do |delta_row|
            next if delta_row == 0 && delta_column >= 0 && delta_column < length
            symbols.include?("#{position[0] + delta_column},#{position[1] + delta_row}")
          end
        end
      end
      .map { |n| n[:number] }
      .sum
  end
end
