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

    pre_rx = modules.keys.select { |n| modules[n][1].include?('rx') }
    pre_pre_rx = modules[pre_rx[0]][2].keys
    unless pre_rx.size == 1 && (pre_rx + pre_pre_rx).all? { |n| modules[n][0] == '&' }
      raise %(
        I made some assumptions about how this problem is assembled based on my
        test input and yours apparently doesn't match mine, which is
        inconceivable but means this solution will not help you. Sorry pal!
      )
    end

    satisfactions = pre_pre_rx.map { |name| [name, nil] }.to_h

    presses = 0
    pulses = []

    loop do
      if pulses.size.zero?
        pulses.push(['button', 'broadcaster', false])
        presses += 1
      end
      from, to, high = pulses.shift
      # puts "#{from} -#{high ? 'high' : 'low'}-> #{to}"
      next if to == 'output'
      type, destinations, state = modules[to]

      case type
      when 'broadcaster'
        destinations.each do |d|
          pulses.push([to, d, high])
        end
      when '%' # flip-flop
        unless high
          modules[to][2] = !modules[to][2]
          new_high = modules[to][2]
          destinations.each do |d|
            pulses.push([to, d, new_high])
          end
        end
      when '&' # conjunction
        modules[to][2][from] = high
        new_high = modules[to][2].any? { |_k, v| !v }

        if new_high && satisfactions.key?(to) && satisfactions[to].nil?
          satisfactions[to] = presses
          break if satisfactions.values.none?(&:nil?)
        end

        destinations.each do |d|
          pulses.push([to, d, new_high])
        end
      end
    end

    satisfactions.values.inject(:*)
  end
end
