class Response
  DIRECTIONS = {
    '^' => [0, -1],
    'v' => [0, 1],
    '<' => [-1, 0],
    '>' => [1, 0]
  }.freeze

  def call(input)
    grid = []
    moves = []
    in_grid = true

    input.each do |line|
      if line == ''
        in_grid = false
        next
      end

      if in_grid
        grid.push(line.split(''))
      else
        moves += line.split('')
      end
    end

    rows = grid.size
    cols = grid.first.size
    walls = []
    obstacles = []
    px = nil
    py = nil

    (0...rows).each do |y|
      (0...cols).each do |x|
        case grid[y][x]
        when '#'
          walls.push([x, y])
        when '@'
          px = x
          py = y
        when 'O'
          obstacles.push([x, y])
        end
      end
    end

    moves.each do |move|
      dx, dy = DIRECTIONS[move]

      cx = px
      cy = py
      moving_obstacles = []
      can_move = false

      loop do
        cx += dx
        cy += dy
        break if walls.include?([cx, cy])
        obstacle = obstacles.find_index { |ox, oy| ox == cx && oy == cy }
        if obstacle
          moving_obstacles.push(obstacle)
        else
          can_move = true
          break
        end
      end

      next unless can_move

      px += dx
      py += dy

      moving_obstacles.each do |mi|
        obstacles[mi][0] += dx
        obstacles[mi][1] += dy
      end
    end

    obstacles
      .map do |x, y|
        y * 100 + x
      end
      .sum
  end
end
