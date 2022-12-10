class Response
  def call(input)
    x = 1
    cycles = 0
    results = []
    iteration = 1
    loop do
      if [20, 60, 100, 140, 180, 220].include?(iteration)
        results.push(iteration * x)
      end

      case input.shift
      when 'noop'
        # proceed
      when /^addx (.+)/
        input.unshift("addy #{Regexp.last_match[1]}")
      when /^addy (.+)/
        x += Regexp.last_match[1].to_i
      else
        raise 'uhhh'
      end

      iteration += 1

      break if iteration == 221
    end

    results.sum
  end
end
