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
    cols = grid.first.size * 2
    walls = []
    obstacles = []
    px = nil
    py = nil

    (0...rows).each do |y|
      (0...cols / 2).each do |x|
        case grid[y][x]
        when '#'
          walls.push([x * 2, y])
          walls.push([x * 2 + 1, y])
        when '@'
          px = x * 2
          py = y
        when 'O'
          obstacles.push([x * 2, y])
        end
      end
    end

    moves.each do |move|
      dx, dy = DIRECTIONS[move]

      pushers = [[px, py]]
      moving_obstacles = []
      can_move = false

      loop do
        checks = pushers.map { |cx, cy| [cx + dx, cy + dy] }
        break if checks.any? { |cx, cy| walls.include?([cx, cy]) }

        pushed_obstacles =
          obstacles.each_with_index.filter_map do |(ox, oy), i|
            next if moving_obstacles.include?(i)

            matches =
              checks.any? do |cx, cy|
                case [dx, dy]
                when [0, -1], [0, 1]
                  oy == cy && (ox == cx || ox + 1 == cx)
                when [-1, 0]
                  ox + 1 == cx && oy == cy
                when [1, 0]
                  ox == cx && oy == cy
                end
              end

            i if matches
          end

        if pushed_obstacles.empty?
          can_move = true
          break
        else
          moving_obstacles += pushed_obstacles
          pushers += pushed_obstacles.map { |i| ox, oy = obstacles[i]; [[ox, oy], [ox + 1, oy]]  }.flatten(1)
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
