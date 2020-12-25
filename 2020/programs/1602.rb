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

    tickets.reject! do |values|
      values.any? do |value|
        ranges.none? { |r| r.include?(value) }
      end
    end

    rule_indices = rules.keys.map { |r| [r, rules.size.times.to_a] }.to_h

    tickets.each do |ticket|
      ticket.each_with_index do |value, index|
        rule_indices.each do |rule, indices|
          next unless indices.include?(index)
          next if rules[rule].any? { |r| r.include?(value) }
          puts "`#{rule}` cannot be #{index}"
          rule_indices[rule] -= [index]
        end
      end
    end

    # TODO: Once you work out which field is which, look for the six fields on
    # your ticket that start with the word departure. What do you get if you
    # multiply those six values together?
  end
end
