class Response
  def call(input)
    input
      .join('')
      .scan(/mul\((\d+),(\d+)\)/)
      .map { |a, b| a.to_i * b.to_i }
      .sum
  end
end
