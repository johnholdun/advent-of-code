require './day'

class Day10Part2< Day
  DAY = 10
  PART = 2

  PositiveInfinity = +1.0/0.0
  NegativeInfinity = -1.0/0.0

  def call
    points =
      input.map do |line|
        line.scan(/position=< *(.+?), *(.+?)> velocity=< *(.+?), *(.+?)>/).flatten.map(&:to_i)
      end

    last_dx = PositiveInfinity
    last_dy = PositiveInfinity
    seconds = 0

    loop do
      min_x = PositiveInfinity
      max_x = NegativeInfinity
      min_y = PositiveInfinity
      max_y = NegativeInfinity

      seconds += 1

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
        return seconds - 1
      end

      last_dx = dx
      last_dy = dy
    end

    raise 'um'
  end
end
