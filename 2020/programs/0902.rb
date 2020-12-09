class Response
  def call(input)
    numbers = input.map(&:to_i)
    exploitable_number, exploitable_index = exploit(numbers)
    range = numbers[0...exploitable_index]
    (3...exploitable_index).each do |length|
      exploit_range =
        range.each_cons(length).find { |addends| addends.sum == exploitable_number }
      next unless exploit_range
      return exploit_range.min + exploit_range.max
    end
    raise StandardError, 'No exploitable range found'
  end

  private

  def exploit(numbers)
    numbers.each_cons(26).each_with_index do |numbers, index|
      check = numbers.last
      addends = numbers[0...-1]
      unless addends.combination(2).map(&:sum).include?(check)
        return [check, index + 26]
      end
    end

    raise StandardError, 'No exploit found'
  end
end
