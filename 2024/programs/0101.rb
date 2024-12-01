class Response
  def call(input)
    lists = input.map { |l| l.split(/\s+/).map(&:to_i) }
    left = lists.map(&:first).sort
    right = lists.map(&:last).sort

    left.each_with_index.map { |n, i| (right[i] - n).abs }.sum
  end
end
