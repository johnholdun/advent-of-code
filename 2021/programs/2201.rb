class Response
  RANGE = (-50..50)

  def call(input)
    directions =
      input.map do |line|
        state, x1, x2, y1, y2, z1, z2 =
          line.scan(/^(on|off) x=(-?\d+)..(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)$/).flatten

        {
          on: state == 'on',
          x: (x1.to_i..x2.to_i),
          y: (y1.to_i..y2.to_i),
          z: (z1.to_i..z2.to_i)
        }
      end

    cubes = Hash.new { |h, k| h[k] = false }

    directions.map { |d| constrain(d) }.compact.each do |direction|
      direction[:x].each do |x|
        direction[:y].each do |y|
          direction[:z].each do |z|
            next unless [x, y, z].all? { |v| RANGE.include?(v) }
            cubes[[x, y, z]] = direction[:on]
          end
        end
      end
    end

    cubes.values.count(&:itself)
  end

  def constrain(direction)
    result = { on: direction[:on] }
    %i(x y z).each do |v|
      range = direction[v]
      return if range.min > 50 || range.max < -50
      result[v] = ([range.min, -50].max..[range.max, 50].min)
    end
    result
  end
end
