require './day'

class Day10Part1 < Day
  DAY = 10
  PART = 1

  PositiveInfinity = +1.0/0.0
  NegativeInfinity = -1.0/0.0

  def call
    points =
      input.map do |line|
        line.scan(/position=< *(.+?), *(.+?)> velocity=< *(.+?), *(.+?)>/).flatten.map(&:to_i)
      end

    last_min_x = PositiveInfinity
    last_min_y = PositiveInfinity
    last_dx = PositiveInfinity
    last_dy = PositiveInfinity
    last_points = []

    loop do
      min_x = PositiveInfinity
      max_x = NegativeInfinity
      min_y = PositiveInfinity
      max_y = NegativeInfinity

      points.each_with_index do |(x, y, dx, dy), i|
        points[i][0] += dx
        points[i][1] += dy

        min_x = [min_x, points[i][0]].min
        max_x = [max_x, points[i][0]].max
        min_y = [min_y, points[i][1]].min
        max_y = [max_y, points[i][1]].max
      end

      dx = max_x - min_x
      dy = max_y - min_y

      # I don't think there was any way to figure this out other than observing
      # the behavior, but I noticed that the points suddently get very close
      # together before drifting apart again, and indeed that was the point when
      # they form a legible image
      if dx > last_dx && dy > last_dy
        (last_dy + 1).times.each do |y|
          (last_dx + 1).times.each do |x|
            print last_points.any? { |px, py| px == x + last_min_x && py == y + last_min_y } ? '#' : ' '
          end
          puts
        end
        puts

        return
      end

      last_dx = dx
      last_dy = dy
      last_points = points.map(&:dup)
      last_min_x = min_x
      last_min_y = min_y
    end

    nil
  end
end
