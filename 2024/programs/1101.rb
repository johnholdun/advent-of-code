class Response
  def call(input)
    stones = input.first.split(' ').map(&:to_i)
    values = Set.new

    25.times do
      stones =
        stones.flat_map do |stone|
          if stone == 0
            1
          elsif stone.to_s.size.even?
            digits = stone.to_s
            [
              digits[0...digits.size / 2].to_i,
              digits[digits.size / 2..].to_i
            ]
          else
            stone * 2024
          end
        end
    end

    stones.size
  end
end
