class Response
  LENGTH = 14

  def call(input)
    input
      .first
      .split('')
      .each_cons(LENGTH)
      .each_with_index
      .find { |l, _| l.uniq.size == l.size }
      .last + LENGTH
  end
end
