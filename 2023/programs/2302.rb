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
    @width = input.first.size

    cells.each do |(x, y), char|
      neighbors[convert([x, y])] =
        # north, south, east, west
        [[0, -1], [0, 1], [1, 0], [-1, 0]].map do |(dx, dy)|
          c = [x + dx, y + dy]
          cells.key?(c) ? convert(c) : nil
        end
    end

    max_y = input.size - 1
    start = convert(cells.keys.find { |_x, y| y.zero? })
    finish = convert(cells.keys.find { |_x, y| y == max_y })

    junctions =
      ([start, finish] + neighbors.keys.select { |i| neighbors[i].count(&:nil?) < 2 })
        .map { |i| [i, neighbors[i].map { |n| n.nil? ? nil : [nil, 0] }]  }
        .to_h

    loop do
      junction = nil
      direction = nil

      junctions.each do |index, directions|
        directions.each_with_index do |dir, dir_index|
          next if dir.nil? || !dir[0].nil?

          junction = index
          direction = dir_index
          break
        end

        break if junction
      end

      break unless junction && direction

      length = 1
      previous = junction
      current = neighbors[junction][direction]

      loop do
        if junctions.key?(current)
          junctions[junction][direction] = [current, length]
          break
        end

        next_current = neighbors[current].compact.find { |i| i != previous }
        previous = current
        current = next_current
        length += 1
      end
    end

    junction_connections =
      junctions
        .map do |id, neighbs|
          [id, neighbs.compact.map(&:first)]
        end
        .to_h

    distances = {}
    junctions.each do |id1, neighbs|
      next if neighbs.nil?
      neighbs.each do |id2, length|
        distances[[id1, id2]] = length
      end
    end

    paths = [[start]]
    finished = []

    loop do
      break if paths.empty?
      path = paths.shift

      if path.last == finish
        finished.push(path.each_cons(2).map { |pair| distances[pair] }.sum)
        next
      end

      junction_connections[path.last].each do |neighbor|
        paths.push(path + [neighbor]) unless path.include?(neighbor)
      end
    end

    finished.max
  end

  private

  attr_reader :width

  def convert(coords)
    x, y = coords
    y * width + x
  end

  def unconvert(index)
    [index % width, index / width]
  end
end
