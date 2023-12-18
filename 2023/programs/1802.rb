class Response
  DIRS = %w(R D L U).freeze

  DELTAS = {
    'D' => [0, 1],
    'U' => [0, -1],
    'L' => [-1, 0],
    'R' => [1, 0]
  }.freeze

  def call(lines)
    perimeter = 0
    points = [[0, 0]]

    lines.each_with_index do |line, index|
      count, dir = line.scan(/#([0-9a-f]{5})([0-3])/).flatten
      count = count.to_i(16)
      dir = DIRS[dir.to_i]

      perimeter += count if %w(U R).include?(dir)

      x, y = points.last

      case dir
      when 'L'
        points.push([x - count, y])
      when 'R'
        points.push([x + count, y])
      when 'U'
        points.push([x, y + count])
      when 'D'
        points.push([x, y - count])
      end
    end

    (
      1 +
      perimeter +
      0.5 * (
        points.each_with_index.map { |(x, _), i| x * points[(i + 1) % points.size][1] }.sum -
        points.each_with_index.map { |(_, y), i| y * points[(i + 1) % points.size][0] }.sum
      ).abs
    ).to_i
  end
end
