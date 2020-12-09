class Response
  def call(input)
    acc = 0

    instructions =
      input.map do |line|
        op, sign, value = line.scan(/^(acc|jmp|nop) ([+-])(\d+)$/).flatten
        value = value.to_i
        value *= -1 if sign == '-'
        [op, value]
      end

    seen = []
    index = 0

    loop do
      break if seen.include?(index)
      seen.push(index)
      op, value = instructions[index]
      case op
      when 'acc'
        acc += value
        index += 1
      when 'jmp'
        index += value
      else
        index += 1
      end
      break if index > instructions.size - 1
    end

    acc
  end
end
