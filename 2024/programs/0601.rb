require 'set'

class Response
  DELTAS =
    {
      0 => [0, -1],
      1 => [1, 0],
      2 => [0, 1],
      3 => [-1, 0]
    }.freeze

  def call(input)
    cols = input.first.size
    rows = input.size
    obstacles = []
    start = nil

    cols.times do |col|
      rows.times do |row|
        case input[row][col]
        when '^'
          start = [col, row]
        when '#'
          obstacles.push([col, row])
        end
      end
    end

    walk(start[0], start[1], 0, rows, cols, obstacles)
  end

  private

  def walk(x, y, direction, rows, cols, obstacles)
    seen = Set.new

    loop do
      obstacle = nil

      obstacles.each do |ox, oy|
        next if [0, 2].include?(direction) && ox != x
        next if [1, 3].include?(direction) && oy != y

        replace =
          case direction
          when 0 then oy < y && (obstacle.nil? || oy > obstacle[1])
          when 1 then ox > x && (obstacle.nil? || ox < obstacle[0])
          when 2 then oy > y && (obstacle.nil? || oy < obstacle[1])
          when 3 then ox < x && (obstacle.nil? || ox > obstacle[0])
          end

        obstacle = [ox, oy] if replace
      end

      out_of_bounds = obstacle.nil?

      if out_of_bounds
        obstacle =
          case direction
          when 0 then [x, -1]
          when 1 then [cols, y]
          when 2 then [x, rows]
          when 3 then [-1, y]
          end
      end

      case direction
      when 0 then (obstacle[1] + 1 .. y).each { |y2| seen.add([x, y2]) }
      when 1 then (x ... obstacle[0]).each { |x2| seen.add([x2, y]) }
      when 2 then (y ... obstacle[1]).each { |y2| seen.add([x, y2]) }
      when 3 then (obstacle[0] + 1 .. x).each { |x2| seen.add([x2, y]) }
      end

      break if out_of_bounds

      dx, dy = DELTAS[direction]
      x = obstacle[0] - dx
      y = obstacle[1] - dy
      direction = (direction + 1) % 4
    end

    seen.size
  end
end
