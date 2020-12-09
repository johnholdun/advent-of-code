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

    instructions.each_with_index.each do |(op, value), index|
      next if op == 'acc'

      new_instructions = instructions.map(&:itself)
      new_instructions[index] = [op == 'jmp' ? 'nop' : 'jmp', value]

      result = execute(new_instructions) rescue nil
      return result if result
    end
  end

  private

  def execute(instructions)
    acc = 0
    seen = []
    index = 0

    loop do
      raise 'Infinite loop!' if seen.include?(index)
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
