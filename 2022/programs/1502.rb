require 'set'

class Response
  MAX = 4000000

  def call(input)
    @ranges = {}

    beacons = Set.new
    sensors = []

    input.each do |line|
      x1, y1, x2, y2 = line.scan(/[xy]=(-?\d+)/).flatten.map(&:to_i)
      beacons.add([x2, y2])
      distance = (x1 - x2).abs + (y1 - y2).abs
      sensors.push([x1, y1, distance])
    end

    (0..MAX).each do |y|
      ranges =
        sensors
          .map do |(x1, y1, distance)|
            vertical_distance = (y - y1).abs
            next if vertical_distance > distance
            width = (vertical_distance - distance).abs
            [x1 - width, x1 + width]
          end
          .compact
          .sort

      x = 0

      loop do
        unless beacons.include?([x, y])
          ranges.each do |left, right|
            break if left > MAX
            x = right + 1 if x >= left && x < right
            break if x > MAX
          end

          return x * 4000000 + y if x <= MAX
        end

        x += 1
        break if x > MAX
      end
    end

    raise 'failed to find a beacon'
  end
end
