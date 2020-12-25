class Response
  def call(input)
    rules = {}
    tickets = []

    input.each do |line|
      case line
      when /^(.+): (\d+)-(\d+) or (\d+)-(\d+)$/
        _, name, min1, max1, min2, max2 = Regexp.last_match.to_a
        rules[name] = [(min1.to_i..max1.to_i), (min2.to_i..max2.to_i)]
      when /^(\d+,)+\d+$/
        tickets.push(line.split(',').map(&:to_i))
      end
    end

    ranges = rules.values.flatten

    tickets.flatten.select do |value|
      ranges.none? { |r| r.include?(value) }
    end.sum
  end
end
