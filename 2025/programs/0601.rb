class Response
  def call(input)
    foobar = []

    input.each do |line|
      line.split(/ +/).each_with_index do |part, x|
        part = part.to_i if part =~ /^\d+$/
        (foobar[x] ||= []).push(part)
      end
    end

    foobar.map do |parts|
      operator = parts.pop
      raise "uhhh #{operator}" unless ['+', '*'].include?(operator)
      parts.inject(operator.to_sym)
    end.sum
  end
end
