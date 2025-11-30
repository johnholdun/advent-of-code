class Response
  def call(input)
    @input_program = input[4].scan(/\d+/).map(&:to_i)
    @program = Program.new(input_program)

    return f(0, 1)

    a = 0

    loop do
      print '.' if a % 100_000 == 0
      return a if program.call([a, 0, 0]) == input_program
      a += 1
    end
  end

  private

  attr_reader :input_program, :program

  def f(a, n)
    return a if n > @input_program.size

    (0...8).each do |i|
      _a = a << 3 | i;
      out = program.call([_a, 0, 0])
      if out == input_program[-n..-1]
        result = f(_a, n + 1)
        if result != false
          return result
        end
      end
    end

    false
  end
end

class Program
  def initialize(program)
    @program = program
    @seen = {}
    @hits = 0
  end

  def call(registers, output = [])
    @seen[registers + output] ||=
      begin
        pointer = 0

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
              if pointer.zero?
                output = call(registers, output)
                break
              end
              jumped = true
            end

          when 4 # bxc
            registers[1] = registers[1] ^ registers[2]

          when 5 # out
            output.push(combo(operand, registers) % 8)
            break if output != program[0...output.size]
          end

          pointer += 2 unless jumped
        end

        output
      end
  end

  private

  attr_reader :registers, :program

  def combo(operand, registers)
    case operand
    when (0..3) then operand
    when (4..6) then registers[operand - 4]
    else throw 'uh oh'
    end
  end
end
