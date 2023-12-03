class Response
  def call(rows)
    gears = []
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
        elsif char == '*'
          gears.push([column, row])
        end
      end
    end

    gears.map do |(g_column, g_row)|
      gear_numbers =
        numbers.select do |number|
          n_column = number[:position][0]
          n_row = number[:position][1]
          length = number[:length]

          n_column >= (g_column - length) &&
          n_column <= (g_column + 1) &&
          n_row >= (g_row - 1) &&
          n_row <= (g_row + 1)
        end

      next 0 if gear_numbers.size != 2

      gear_numbers.map { |n| n[:number] }.inject(:*)
    end
    .sum
  end
end
