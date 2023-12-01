class Response
  def call(input)
    input
      .map do |line|
        digits = line.scan(/[0-9]/)
        [digits.first, digits.last].join.to_i
      end
      .sum
  end
end
