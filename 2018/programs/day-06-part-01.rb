require './day'

class Day6Part1 < Day
  DAY = 6
  PART = 1

  def call
    points =
      input
        .each_with_index
        .map do |pair, index|
          x, y = pair.split(', ').map(&:to_i)
          { index: index, x: x, y: y }
        end

    bounds =
      [
        {
          x: points.map { |p| p[:x] }.min - 1,
          y: points.map { |p| p[:y] }.min - 1
        },
        {
          x: points.map { |p| p[:x] }.max + 1,
          y: points.map { |p| p[:y] }.max + 1
        }
      ]

    areas = {}

    (bounds[0][:x]..bounds[1][:x]).each do |x|
      (bounds[0][:y]..bounds[1][:y]).each do |y|
        distances =
          points.group_by do |point|
            (point[:y] - y).abs + (point[:x] - x).abs
          end

        closest_points = distances[distances.keys.min]

        if bounds.any? { |b| b[:x] == x || b[:y] == y }
          closest_points.each do |point|
            areas[point[:index]] ||= {}
            areas[point[:index]][:infinite] = true
          end
        end

        next if closest_points.size > 1

        areas[closest_points[0][:index]] ||= {}
        areas[closest_points[0][:index]][:size] ||= 0
        areas[closest_points[0][:index]][:size] += 1
      end
    end

    areas.values.reject { |a| a[:infinite] }.map { |a| a[:size] }.max
  end
end
