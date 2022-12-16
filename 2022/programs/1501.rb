require 'set'

class Response
  CHECK_Y = 2000000

  def call(input)
    ranges = []
    beacons = Set.new

    # pull out the coordinates of each beacon, then find all the non-beacon
    # ranges for each sensor
    input.each do |line|
      x1, y1, x2, y2 = line.scan(/[xy]=(-?\d+)/).flatten.map(&:to_i)
      beacons.add([x2, y2])
      distance = (x1 - x2).abs + (y1 - y2).abs
      vertical_distance = (CHECK_Y - y1).abs
      next if vertical_distance > distance
      width = (vertical_distance - distance).abs
      ranges.push([x1 - width, x1 + width])
    end

    # collapse overlapping ranges
    loop do
      size_before = ranges.size
      ranges =
        ranges.inject([]) do |memo, a|
          found = false
          memo.each_with_index do |b, index|
            next if a[1] < (b[0] - 1) || b[1] < (a[0] - 1)
            found = true
            memo[index] = [[a[0], b[0]].min, [a[1], b[1]].max]
          end

          memo.push(a) unless found
          memo
        end
      break if ranges.size == size_before
    end

    # remove any spaces from the count that contain a beacon
    subtractions = beacons.count { |s| s[1] == CHECK_Y }

    # turn ranges into the length of each range, then remove beacons
    return ranges.map { |(a, b)| b - a + 1 }.sum - subtractions
  end
end
