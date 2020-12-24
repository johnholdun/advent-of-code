class Response
  def call(input)
    ids =
      input
        .last
        .split(',')
        .map { |i| i.to_i unless i == 'x' }
        .each_with_index
        .to_a
        .reject { |i, _| i.nil? }

    # TODO: What is the earliest timestamp such that all of the listed bus IDs
    # depart at offsets matching their positions in the list?
  end
end
