class Response
  def call(input)
    input
      .map { |i| i.split(/:? /).map(&:to_i) }
      .select { |total, *operands| possible?(total, operands) }
      .map(&:first)
      .sum
  end

  private

  def possible?(total, operands)
    # we enumerate every possible combination of operators by creating a binary
    # number where 0s are multiplication and 1s are addition
    max = ('1' * operands.size).to_i(2)

    (0..max).each do |i|
      # a janky way to zero-pad the binary representation of a number
      binary = ('0' * operands.size + i.to_s(2)).slice(-1 * (operands.size - 1) .. -1).split('')

      operators = binary.map { |b| b == '0' ? :* : :+ }
      return true if total == operands.inject { |a, b| a.send(operators.shift, b) }
    end

    false
  end
end
