class Response
  def call(input)
    x1, x2, y1, y2 =
      input.first
        .scan(/^target area: x=(-?\d+)\.\.(-?\d+), y=(-?\d+)\.\.(-?\d+)$/)
        .flatten
        .map(&:to_i)

    target_x_range = (x1..x2)
    target_y_range = (y1..y2)
    hitting_positions = []

    max_y_distance = [target_y_range.min.abs, target_y_range.max.abs].max

    (0..target_x_range.max).each do |dx|
      (max_y_distance * -1..max_y_distance).each do |dy|
        positions = path(dx, dy, target_x_range, target_y_range)
        hitting_positions.push([dx, dy, positions]) if positions
      end
    end

    hitting_positions.size
  end

  private

  def path(dx, dy, x_range, y_range)
    positions = [[0, 0]]

    loop do
      x, y = positions.last
      x = x + dx
      y = y + dy
      positions.push([x, y])

      if x > x_range.max || y < y_range.min
        return nil
      end

      if x >= x_range.min && y <= y_range.max
        return positions
      end

      dx = [dx - 1, 0].max
      dy -= 1
    end
  end
end
