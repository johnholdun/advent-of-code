class Response
  DELTAS = [
    [0, -1],
    [1, 0],
    [0, 1],
    [-1, 0]
  ].freeze

  def call(input)
    rows = 70
    cols = 70
    start = [0, 0]
    goal = [70, 70]
    obstacles = input[0...1024].map { |i| i.split(',').map(&:to_i) }

    open_set = Set.new([start])

    cameFrom = {}
    gScore = { start => 0 }
    fScore = { start => h(start, goal) }

    loop do
      break if open_set.empty?
      current = nil
      cost = nil

      open_set.each do |s|
        new_cost = fScore[s]

        if cost.nil? || new_cost < cost
          current = s
          cost = new_cost
        end
      end

      x, y = current

      open_set.delete(current)
      tentative_gScore = gScore[current] + 1

      DELTAS.each do |dx, dy|
        neighbor = [x + dx, y + dy]
        next if obstacles.include?(neighbor)

        if gScore[neighbor].nil? || tentative_gScore < gScore[neighbor]
          cameFrom[neighbor] = current
          gScore[neighbor] = tentative_gScore
          fScore[neighbor] = tentative_gScore + h(neighbor, goal)
          open_set.add(neighbor)
        end
      end
    end

    current = goal
    total_path = [current]

    loop do
      current = cameFrom[current]
      break unless current
      total_path.unshift(current)
    end

    total_path.size
  end

  private

  def h(node, goal)
    nx, ny = node
    gx, gy = goal
    (gy - ny) ** 2 + (gx - nx) ** 2
  end
end
