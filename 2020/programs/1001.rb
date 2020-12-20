class Response
  def call(input)
    adapters = input.map(&:to_i).sort
    differences = adapters.each_cons(2).map { |a, b| b - a }
    (differences.count(3) + 1) * (differences.count(1) + 1)
  end
end
