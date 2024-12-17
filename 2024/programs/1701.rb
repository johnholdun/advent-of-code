class Response
  def call(input)
    registers = input[0..2].map { |l| l.scan(/\d+/).first.to_i }
    program = input[4].scan(/\d+/).map(&:to_i)
    pointer = 0
    output = []

    loop do
      break if pointer >= program.size
      opcode = program[pointer]
      operand = program[pointer + 1]
      jumped = false

      case opcode
      when 0, 6, 7 # adv, bdv, cdv
        numerator = registers[0]
        denominator = 2 ** combo(operand, registers)
        result = numerator / denominator
        stored_register_index = [0, opcode - 5].max
        registers[stored_register_index] = result

      when 1 # bxl
        registers[1] = registers[1] ^ operand

      when 2 # bst
        registers[1] = combo(operand, registers) % 8

      when 3 # jnz
        unless registers[0].zero?
          pointer = operand
          jumped = true
        end

      when 4 # bxc
        registers[1] = registers[1] ^ registers[2]

      when 5 # out
        output.push(combo(operand, registers) % 8)
      end

      pointer += 2 unless jumped
    end

    output.join(',')
  end

  private

  def combo(operand, registers)
    case operand
    when (0..3) then operand
    when (4..6) then registers[operand - 4]
    else throw 'uh oh'
    end
  end
end
