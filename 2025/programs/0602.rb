class Response
  def call(input)
    lines = input.map { |line| line.split('') }
    size = lines.first.size

    foobar = [[]]

    size.times do |x|
      column = lines.map { |l| l[size - 1 - x, 1] }.join('')
      number, operator = column.scan(/^ *(\d+) *([+*])?$/).flatten

      foobar.last.push(number.to_i) if number

      if operator
        foobar.last.push(operator.to_sym)
        foobar.push([])
      end
    end

    foobar.map do |parts|
      next 0 if parts.size.zero?
      operator = parts.pop
      raise "uhhh #{operator}" unless [:+, :*].include?(operator)
      parts.inject(operator)
    end.sum
  end
end
