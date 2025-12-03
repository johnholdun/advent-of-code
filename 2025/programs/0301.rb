class Response
  def call(input)
    input
      .map do |bank|
        values = bank.split('').map(&:to_i)
        tens = values[0...-1].max
        tens_index = values.index(tens)
        ones = values[(tens_index + 1)..].max
        tens * 10 + ones
      end
      .sum
  end
end
