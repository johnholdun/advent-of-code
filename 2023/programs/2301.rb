class Response
  def call(input)
    cells = {}

    input.each_with_index do |line, y|
      line.chars.each_with_index do |char, x|
        next if char == '#'
        cells[[x, y]] = char
      end
    end

    neighbors = {}

    cells.each do |(x, y), char|
      neighbors[[x, y]] =
        case char
        when '.' then [[-1, 0], [1, 0], [0, -1], [0, 1]]
        when '>' then [[1, 0]]
        when '<' then [[-1, 0]]
        when '^' then [[0, -1]]
        when 'v' then [[0, 1]]
        end
        .map { |(dx, dy)| [x + dx, y + dy] }
        .select { |c| cells.key?(c) }
    end

    max_y = input.size - 1
    start = cells.keys.find { |_x, y| y.zero? }
    finish = cells.keys.find { |_x, y| y == max_y }

    paths = [[start]]
    finished = []

    loop do
      break if paths.empty?
      path = paths.shift

      if path.last == finish
        finished.push(path.size - 1)
        next
      end

      neighbors[path.last].each do |neighbor|
        paths.push(path + [neighbor]) unless path.include?(neighbor)
      end
    end

    finished.max
  end
end
