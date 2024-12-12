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

      next_point =
        (0...@rows * @cols).find do |index|
          !@regions[[index % @rows, (index / @cols).floor]]
        end
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
    sides = 0
    edges = {
      horizontal: [],
      vertical: []
    }

    points.each do |x, y|
      NEIGHBORS.each do |dx, dy|
        x2 = x + dx
        y2 = y + dy
        next if points.include?([x2, y2])
        orientation = dx.zero? ? :horizontal : :vertical
        # edges are defined as the top or left side of a cell at their given
        # coordinate
        x2 -= 1 if orientation == :vertical && dx > 0
        y2 -= 1 if orientation == :horizontal && dy > 0

        x2 += 1 if orientation == :vertical
        y2 += 1 if orientation == :horizontal

        edges[orientation].push([x2, y2])
      end
    end

    edges.each do |orientation, positions|
      parallel_direction = orientation == :horizontal ? 0 : 1
      perpendicular_direction = orientation == :horizontal ? 1 : 0
      positions.map { |p| p[perpendicular_direction] }.uniq.each do |position|
        starts =
          positions
            .select { |p| p[perpendicular_direction] == position }
            .map { |p| p[parallel_direction] }
            .uniq
            .sort

        starts.each_with_index do |start, index|
          new_side = 0 if index.zero?

          unless new_side
            new_side = 1 if starts[index - 1] != start - 1
          end

          other_orientation = orientation == :vertical ? :horizontal : :vertical

          unless new_side
            this_point = []
            this_point[perpendicular_direction] = position
            this_point[parallel_direction] = start
            intersection = [this_point.dup, this_point.dup]
            intersection[0][perpendicular_direction] -= 1

            new_side = 2 if (intersection & edges[other_orientation]).size > 0
          end

          sides += 1 if new_side
        end
      end
    end

    area * sides
  end
end
