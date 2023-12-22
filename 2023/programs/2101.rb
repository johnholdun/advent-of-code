class Response
  def call(input)
    cells = {}
    start = nil
    input.each_with_index do |line, y|
      line.chars.each_with_index do |char, x|
        next if char == '#'
        start = [x, y] if char == 'S'
        cells[[x, y]] = true
      end
    end

    cells.each do |(x, y), _v|
      cells[[x, y]] =
        [[-1, 0], [1, 0], [0, -1], [0, 1]]
          .map { |dx, dy| [x + dx, y + dy] }
          .select { |nx, ny| cells.key?([nx, ny]) }
    end

    seen = {}
    count = 0

    64.times do |i|
      origins = (seen.size.zero? ? [start] : seen.keys)
      seen = {}
      origins.each do |x, y|
        cells[[x, y]].each do |nx, ny|
          seen[[nx, ny]] = true
        end
      end
    end

    seen.size
    # 1840 too low
    # 7458 too high!
  end
end
