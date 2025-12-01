class Response
  def call(input)
    position = 50
    zeroes = 0

    input.each do |line|
      mult = line[0, 1] == 'L' ? -1 : 1
      count = line[1..].to_i
      position += count * mult
      loop do
        break if position >= 0
        position += 100
      end
      position %= 100
      zeroes += 1 if position.zero?
    end

    zeroes
  end
end
