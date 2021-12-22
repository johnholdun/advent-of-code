class Range
  def intersection(range)
    min1, max1, min2, max2 = [self, range].sort_by(&:min).flat_map(&:minmax)

    return nil if max1 < min2

    (min2..[max1, max2].min)
  end
end

class Cube
  def initialize(x, y, z)
    @x = x
    @y = y
    @z = y
  end

  def [](axis)
    case axis
    when :x then x
    when :y then y
    when :z then z
    else raise ArgumentError
    end
  end

  def volume
    @volume ||= %i(x y z).map { |a| self[a].max - self[a].min }.inject(:+)
  end

  def intersection(cube)
    x, y, z =
      %i(x y z).map do |a|
        new_axis = self[a].intersection(cube[a])
        return nil if new_axis.nil?
        new_axis
      end
    Cube.new(x, y, z)
  end

  private

  attr_reader :x, :y, :z
end

class Response
  RANGE = (-50..50)

  def call(input)
    directions =
      input.map do |line|
        state, x1, x2, y1, y2, z1, z2 =
          line.scan(/^(on|off) x=(-?\d+)..(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)$/).flatten

        cube =
          Cube.new \
            (x1.to_i..x2.to_i),
            (y1.to_i..y2.to_i),
            (z1.to_i..z2.to_i)

        [cube, state == 'on']
      end

    negations =
      directions.each_with_index.select do |(cube1, state), index|
        directions[index + 1..-1].any? do |cube2, state|
          intersection = cube1.intersection(cube2)
          intersection && intersection.volume == cube1.volume
        end
      end.map(&:last)

    negations.reverse.each do |index|
      directions.delete_at(index)
    end

    return directions.size

    activations = directions.select(&:last)

    bounds = %i(x y z).map do |a|
      ranges = activations.map { |d| d[a] }
      min = ranges.map(&:min).min
      max = ranges.map(&:max).max
      [a, (min..max)]
    end.to_h

    count = 0
    tried = 0

    puts bounds.values.map { |r| r.max - r.min }.inject(:*)

    bounds[:x].each do |x|
      bounds[:y].each do |y|
        bounds[:z].each do |z|
          count += 1 if active?(x, y, z, directions)
          tried += 1
          print '.' if tried % 1000 == 0
        end
      end
    end

    count
  end

  private

  def active?(x, y, z, directions)
    direction =
      directions.reverse.find do |d|
        d[:x].include?(x) && d[:y].include?(y) && d[:z].include?(z)
      end

    direction ? direction[:on] : false
  end
end
