class Response
  def call(input)
    input
      .flat_map do |bank|
        values = bank.split('').map(&:to_i)
        last_index = -1

        12.times.map do |i|
          digits = values[(last_index + 1)..i - 12]
          digit = digits.max
          last_index += digits.index(digit) + 1
          digit * 10 ** (12 - i - 1)
        end
      end
      .sum
  end
end
