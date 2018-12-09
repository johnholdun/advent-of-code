require './day'

class Day6Part2 < Day
  DAY = 6
  PART = 2

  def call
    points = input.map { |p| p.split(', ').map(&:to_i) }

    xs = points.map(&:first).sort
    ys = points.map(&:last).sort

    area = 0

    (xs.first..xs.last).each do |x|
      (ys.first..ys.last).each do |y|
        sum = points.inject(0) { |t, (px, py)| t + (x - px).abs + (y - py).abs }
        area += 1 if sum < 10_000
      end
    end

    area
  end
end
