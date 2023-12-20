class Response
  def call(input)
    conjunctions = []

    modules =
      input
      .map do |line|
        name, destinations = line.split(' -> ')
        type =
          case name
          when 'broadcaster' then 'broadcaster'
          when /^(.)/ then Regexp.last_match[1]
          end
        state =
          case type
          when '%'
            false
          when '&'
            {}
          end
        stripped_name = name.sub(/^[&%]/, '')
        conjunctions.push(stripped_name) if type == '&'
        [stripped_name, [type, destinations.split(', '), state]]
      end
      .to_h

    conjunctions.each do |name|
      modules[name][2] =
        modules
          .select do |_name, (_type, destinations, _state)|
            destinations.include?(name)
          end
          .map { |name, _val| [name, false] }
          .to_h
    end

    pushes = 1000
    total_pulses = { true => 0, false => pushes }
    pulses = []

    loop do
      if pulses.size.zero?
        break if pushes.zero?
        pulses.push(['button', 'broadcaster', false])
        pushes -= 1
      end
      from, to, high = pulses.shift
      # puts "#{from} -#{high ? 'high' : 'low'}-> #{to}"
      next if to == 'output'
      type, destinations, state = modules[to]

      case type
      when 'broadcaster'
        total_pulses[high] += destinations.size
        destinations.each do |d|
          pulses.push([to, d, high])
        end
      when '%' # flip-flop
        unless high
          modules[to][2] = !modules[to][2]
          new_high = modules[to][2]
          total_pulses[new_high] += destinations.size
          destinations.each do |d|
            pulses.push([to, d, new_high])
          end
        end
      when '&' # conjunction
        modules[to][2][from] = high
        new_high = modules[to][2].any? { |_k, v| !v }
        total_pulses[new_high] += destinations.size
        destinations.each do |d|
          pulses.push([to, d, new_high])
        end
      end
    end

    total_pulses.values.inject(:*)
  end
end
