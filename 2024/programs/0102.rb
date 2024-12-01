class Response
  def call(input)
    lists = input.map { |l| l.split(/\s+/).map(&:to_i) }
    left = lists.map(&:first).sort
    right = lists.map(&:last).sort

    left.map { |l| l * right.count(l) }.sum
  end
end
