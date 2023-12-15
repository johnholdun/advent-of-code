class Response
  def call(input)
    input
      .first
      .split(',')
      .map do |string|
        value = 0
        string.chars.each do |char|
          value = ((value + char.ord) * 17) % 256
        end
        value
      end
      .sum
  end
end
