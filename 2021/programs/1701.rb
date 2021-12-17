class Response
  def call(input)
    x1, x2, y1, y2 =
      input.first
        .scan(/^target area: x=(-?\d+)\.\.(-?\d+), y=(-?\d+)\.\.(-?\d+)$/)
        .flatten
        .map(&:to_i)

    x_range = (x1..x2)
    y_range = (y1..y2)
    max_height = 0

    (1...x_range.max).each do |dx|
      (1...y_range.min.abs).each do |dy|
        positions = path(dx, dy, x_range, y_range)
        max_height = ([max_height] + positions.map(&:last)).max if positions
      end
    end

    max_height
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

      if x > x_range.min && y < y_range.max
        return positions
      end

      dx = [dx - 1, 0].max
      dy -= 1
    end
  end
end
