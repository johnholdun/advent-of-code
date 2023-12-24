class Response
  def call(input)
    things =
      input.map do |line|
        px, py, pz, vx, vy, vz =
          line
            .scan(/^(-?\d+), *(-?\d+), *(-?\d+) *@ *(-?\d+), *(-?\d+), *(-?\d+)$/)
            .flatten
            .map(&:to_i)

        slope = vy / vx.to_f
        intercept = py - slope * px

        [slope, intercept, [px, py, pz], [vx, vy, vz]]
      end

    intersections = 0
    min = 200000000000000
    max = 400000000000000

    things[0..-2].each_with_index do |(slope_a, intercept_a, pos_a, vel_a), i|
      things[i + 1..-1].each do |slope_b, intercept_b, pos_b, vel_b|
        # parallel, no
        next if slope_a == slope_b

        x = (intercept_b - intercept_a) / (slope_a - slope_b).to_f
        y = slope_a * x + intercept_a

        # outside, no
        next if x < min || x > max || y < min || y > max

        # a would have intersected in the past
        next if pos_a[0] > x == vel_a[0] > 0

        # b would have intersected in the past
        next if past_b = pos_b[0] > x == vel_b[0] > 0

        intersections += 1
      end
    end

    intersections
  end
end
