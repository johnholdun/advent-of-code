class Response
  def call(input)
    sequence = input.first.split(',').map(&:to_i).reverse

    2020.times do |i|
      next if sequence[(i + 1) * -1]
      sequence.unshift((sequence[1..-1].find_index(sequence.first) || -1) + 1)
    end

    sequence.first
  end
end
