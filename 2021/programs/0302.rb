class Response
  def call(input)
    @bits = input.map { |l| l.split('').map(&:to_i) }
    criteria_match(:oxygen) * criteria_match(:co2)
  end

  private

  attr_reader :bits

  def commonest(values, index)
    zeroes = values.map { |b| b[index] }.count(&:zero?)
    ones = values.size - zeroes
    return -1 if ones == zeroes
    ones > zeroes ? 1 : 0
  end

  def match_bit_for_flavor(flavor, index, matches)
    bit = commonest(matches, index)

    case flavor
    when :oxygen
      bit == -1 ? 1 : bit
    when :co2
      bit == -1 ? 0 : bit * -1 + 1
    else
      raise ArgumentError, 'bad flavor'
    end
  end

  def criteria_match(flavor)
    matches =
      bits.first.size.times.inject(bits) do |matches, index|
        break matches if matches.size == 1
        match_bit = match_bit_for_flavor(flavor, index, matches)
        matches.select { |v| v[index] == match_bit }
      end

    raise 'aw beans' unless matches.size == 1
    matches.first.join.to_i(2)
  end
end
