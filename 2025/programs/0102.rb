class Response
  def call(input)
    position = 50
    zeroes = 0

    # i tried a lot of things that were more clever and efficient than this and
    # none of them worked so…here
    input.each do |line|
      direction = (line[0, 1] == 'L' ? -1 : 1)
      count = line[1..].to_i
      count.times do
        position += direction
        position -= 100 if position > 99
        position += 100 if position < 0
        zeroes += 1 if position.zero?
      end
    end

    zeroes
  end
end
