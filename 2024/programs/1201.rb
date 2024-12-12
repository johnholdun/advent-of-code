class Response
  NEIGHBORS = [[-1, 0], [0, -1], [1, 0], [0, 1]].freeze

  def call(input)
    @grid = input.map { |l| l.split('') }
    @rows = @grid.size
    @cols = @grid.first.size
    @regions = {}
    @region_count = 0

    x = 0
    y = 0

    loop do
      region = @regions[[x, y]]

      if region.nil?
        region = @region_count
        @region_count += 1
        @regions[[x, y]] = region
      end

      walk(x, y)

      next_point = (0...@rows * @cols).find { |i| !@regions[[i % @rows, (i / @cols).floor]] }
      break unless next_point
      x = next_point % @rows
      y = (next_point / @cols).floor
    end

    (0...@region_count)
      .map { |i| score(@regions.filter { |_, v| v == i }.keys) }
      .sum
  end

  private

  def walk(x, y)
    char = @grid[y][x]
    region = @regions[[x, y]]

    NEIGHBORS.each do |dx, dy|
      x2 = x + dx
      y2 = y + dy
      next unless (0...@cols).include?(x2) && (0...@rows).include?(y2)
      next unless @grid[y2][x2] == char
      region2 = @regions[[x2, y2]]
      next if region2 == region
      if region2
        @regions.each do |(x, y), old_region|
          @regions[[x, y]] = region if old_region == region2
        end
      else
        @regions[[x2, y2]] = region
      end
      walk(x2, y2)
    end
  end

  def score(points)
    area = points.size
    perimeter =
      points
        .map do |x, y|
          NEIGHBORS.count { |dx, dy| !points.include?([x + dx, y + dy]) }
        end
        .sum

    area * perimeter
  end
end
