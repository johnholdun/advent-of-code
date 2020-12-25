class Response
  def call(input)
    sequence = input.first.split(',').map(&:to_i).reverse

    # TODO: Given your starting numbers, what will be the 30000000th number spoken?
  end
end
