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

    path, _ = walk(start[0], start[1], 0, rows, cols, obstacles)

    # I tried a lot of things to narrow this list down intelligently and they
    # all introduced subtle errors so I am just checking every single step on
    # the regular path, IT'S FINE
    possibles = path.map { |x, y, d| [x, y] }.uniq
    possibles -= [start]
    possibles -= obstacles

    possibles.count do |obs|
      _, loops = walk(start[0], start[1], 0, rows, cols, obstacles + [obs])
      loops
    end
  end

  private

  def walk(x, y, direction, rows, cols, obstacles)
    seen = []

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

      next_seen =
        case direction
        when 0 then (obstacle[1] + 1 .. y).map { |y2| [x, y2, direction] }
        when 1 then (x ... obstacle[0]).map { |x2| [x2, y, direction] }
        when 2 then (y ... obstacle[1]).map { |y2| [x, y2, direction] }
        when 3 then (obstacle[0] + 1 .. x).map { |x2| [x2, y, direction] }
        end

      looping = !(seen & next_seen).empty?
      seen += next_seen

      return [seen, true] if looping
      return [seen, false] if out_of_bounds

      dx, dy = DELTAS[direction]
      x = obstacle[0] - dx
      y = obstacle[1] - dy
      direction = (direction + 1) % 4
    end
  end
end
