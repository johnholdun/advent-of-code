class Response
  DIGITS = %w(_zero one two three four five six seven eight nine).freeze

  def call(input)
    input.sum do |line|
      # My solution to part one was too naïve because apparently the letters
      # of the names of digits can overlap, i.e. "oneight" should be
      # interpreted as [1, 8]. Feels like this might still be solveable with a
      # single regex but this works too.
      digits = []

      line.split('').each_with_index do |char, index|
        if char =~ /[1-9]/
          digits.push(char)
          next
        end

        DIGITS.each do |digit|
          if line[index, digit.size] == digit
            digits.push(DIGITS.index(digit).to_s)
            break
          end
        end
      end

      [digits.first, digits.last].join.to_i
    end
  end
end
