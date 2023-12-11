require 'set'

class Response
  def call(lines)
    map = {}
    start = nil
    the_loop = {}

    lines.each_with_index do |line, row|
      line.split('').each_with_index do |tile, column|
        next if tile == '.'
        key = [row, column]
        start = key if tile == 'S'

        map[key] =
          case tile
          when '|' then [[row - 1, column], [row + 1, column]]
          when '-' then [[row, column - 1], [row, column + 1]]
          when 'L' then [[row - 1, column], [row, column + 1]]
          when 'J' then [[row - 1, column], [row, column - 1]]
          when '7' then [[row + 1, column], [row, column - 1]]
          when 'F' then [[row + 1, column], [row, column + 1]]
          when 'S' then []
          end
      end
    end

    [[-1, 0], [1, 0], [0, -1], [0, 1]].map do |(dx, dy)|
      key = [start[0] + dx, start[1] + dy]
      map[start].push(key) if map[key].include?(start)
    end

    the_loop = { start => true }
    last_key = start

    loop do
      n1, n2 = map[last_key]
      last_key = nil

      if the_loop.include?(n1)
        unless the_loop.include?(n2)
          last_key = n2
        end
      else
        last_key = n1
      end

      break unless last_key
      the_loop[last_key] = true
    end

    the_loop.size / 2
  end
end
