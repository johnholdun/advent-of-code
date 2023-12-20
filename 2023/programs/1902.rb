class Response
  def call(input)
    workflows = {}

    input.each do |line|
      break if line == ''

      name, rest = line.scan(/^(.+)\{(.+)\}/).to_a.flatten
      steps =
        rest.split(',').map do |step|
          if step =~ /^[a-z]+$/i
            [nil, nil, nil, step]
          else
            parameter, operator, value, destination = step.scan(/(.)(.)(\d+):(.+)/).to_a.flatten
            [parameter, operator, value.to_i, destination]
          end
        end

      workflows[name] = steps
    end

    parts = [{ x: (1...4001), m: (1...4001), a: (1...4001), s: (1...4001), place: ['in', 0] }]
    count = 0

    loop do
      break if parts.size.zero?
      part = parts.pop

      name, index = part[:place]
      parameter, operator, value, destination =
        if %w(A R).include?(name)
          [nil, nil, nil, name]
        else
          workflows[name][index]
        end

      if parameter.nil?
        case destination
        when 'A'
          count += [:x, :m, :a, :s].map { |p| part[p].size }.inject(:*)
        when 'R'
          # goodbye
        else
          parts.push(part.merge(place: [destination, 0]))
        end
      else
        parameter = parameter.to_sym
        min = part[parameter].first
        max = part[parameter].last
        split = value.to_i

        case operator
        when '<'
          if min < split
            parts.push(part.merge(parameter => (min...split), place: [destination, 0]))
          end

          if max > split
            parts.push(part.merge(parameter => (split...max), place: [name, index + 1]))
          end
        when '>'
          if max > split
            parts.push(part.merge(parameter => (split + 1...max), place: [destination, 0]))
          end

          if min < split
            parts.push(part.merge(parameter => (min...split + 1), place: [name, index + 1]))
          end
        else raise 'uh?'
        end
      end
    end

    count
  end
end
