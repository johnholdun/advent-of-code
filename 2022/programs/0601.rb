class Response
  def call(input)
    input
      .first
      .split('')
      .each_cons(4)
      .each_with_index
      .find { |l, _| l.uniq.size == l.size }
      .last + 4
  end
end
