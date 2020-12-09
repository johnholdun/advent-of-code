class Response
  def call(input)
    input.map(&:to_i).each_cons(26) do |numbers|
      check = numbers.last
      addends = numbers[0...-1]
      return check unless addends.combination(2).map(&:sum).include?(check)
    end
  end
end
