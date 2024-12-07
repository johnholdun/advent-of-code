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
    # we enumerate every possible combination of operators by creating a base-3
    # number where 0s are multiplication, 1s are addition, and 2s are
    # concatenation
    max = ('2' * (operands.size - 1)).to_i(3)

    (0..max).each do |i|
      test_operands = operands.dup
      # a janky way to zero-pad the binary representation of a number
      operators = ('0' * operands.size + i.to_s(3)).slice(-1 * (operands.size - 1) .. -1).split('').map(&:to_i)

      test_total = test_operands.shift

      loop do
        break if test_operands.empty?
        right = test_operands.shift

        case operators.shift
        when 0
          test_total *= right
        when 1
          test_total += right
        when 2
          test_total = "#{test_total}#{right}".to_i
        end

        break if test_total > total
      end

      return true if total == test_total
    end

    false
  end
end
