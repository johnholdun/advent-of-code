class Response
  def call(input)
    program =
      input.first.split('').each_with_index.flat_map do |count, index|
        [(index % 2 == 0 ? index / 2 : -1)] * count.to_i
      end

    left_index = 0
    right_index = program.size - 1
    result = []

    loop do
      if program[left_index] == -1
        next_value = nil

        loop do
          next_value = program[right_index]
          right_index -= 1
          break if next_value > -1
        end

        result.push(next_value)
      else
        result.push(program[left_index])
      end

      left_index += 1

      break if left_index > right_index
    end

    result.each_with_index.map { |n, i| n * i }.sum
  end
end
