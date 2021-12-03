class Response
  def call(input)
    bits = input.map { |l| l.split('').map(&:to_i) }

    gamma = []
    epsilon = []

    bits.first.size.times do |n|
      zeroes = bits.map { |b| b[n] }.count(&:zero?)
      ones = bits.size - zeroes
      greater = ones > zeroes ? 1 : 0
      gamma[n] = greater
      epsilon[n] = greater * -1 + 1
    end

    gamma.join.to_i(2) * epsilon.join.to_i(2)
  end
end
