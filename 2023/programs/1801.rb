class Response
  DELTAS = {
    'D' => [0, 1],
    'U' => [0, -1],
    'L' => [-1, 0],
    'R' => [1, 0]
  }.freeze

  def call(lines)  
    field = { [0, 0] => true }
    previous = [0, 0]

    first = nil
    last = nil

    lines.each_with_index do |line, index|
      dir, count = line.scan(/^(.) (\d+)/).flatten
      first = dir if index == 0
      last = dir if index == lines.size - 1
      dx, dy = DELTAS[dir]
      count.to_i.times do
        x, y = previous
        previous = [x + dx, y + dy]
        field[previous] = true
      end
    end

    probe =
      case [first, last].sort.join
      when 'LU' then [-1, -1]
      when 'RU' then [1, -1]
      when 'DL' then [-1, 1]
      when 'DR' then [1, 1]
      end

    fillers = [probe]

    loop do
      fx, fy = fillers.shift

      [[-1, 0], [1, 0], [0, 1], [0, -1]].each do |dx, dy|
        x = fx + dx
        y = fy + dy
        next if field[[x, y]]
        field[[x, y]] = true
        fillers.push([x, y])
      end

      break if fillers.size.zero?
    end

    field.size
  end
end
