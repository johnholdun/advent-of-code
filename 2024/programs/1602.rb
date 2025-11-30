class Response
  DELTAS = {
    north: [0, -1],
    east: [1, 0],
    south: [0, 1],
    west: [-1, 0]
  }.freeze

  def call(input)
    places = {}
    start = nil
    goal = nil

    input.each_with_index do |row, y|
      row.split('').each_with_index do |cell, x|
        next if cell == '#'
        places[[x, y]] = true
        if cell == 'S'
          start = [x, y]
        elsif cell == 'E'
          goal = [x, y]
        end
      end
    end

    current_direction = :east

    open_set = Set.new([[start, current_direction]])

    cameFrom = {}
    gScore = { [start, current_direction] => 0 }
    fScore = { [start, current_direction] => h([start, current_direction], goal) }

    loop do
      break if open_set.empty?
      # This operation can occur in O(Log(N)) time if open_set is a min-heap or a priority queue
      current = nil
      cost = nil

      open_set.each do |s|
        new_cost = fScore[s]

        if cost.nil? || new_cost < cost
          current = s
          cost = new_cost
        end
      end

      from, direction = current
      x, y = from

      open_set.delete(current)

      DELTAS.each do |next_direction, (dx, dy)|
        to = [x + dx, y + dy]
        neighbor = [to, next_direction]
        next unless places[to]
        neighbor_cost = direction == next_direction ? 1 : 1001
        tentative_gScore = gScore[current] + neighbor_cost

        if gScore[neighbor].nil? || tentative_gScore < gScore[neighbor]
          # This path to neighbor is better than any previous one. Record it!
          cameFrom[neighbor] = current
          gScore[neighbor] = tentative_gScore
          fScore[neighbor] = tentative_gScore + h(neighbor, goal)
          open_set.add(neighbor)
        end
      end
    end

    points = Set.new([goal])
    score = gScore.filter_map { |(pos, _), cost| cost if pos == goal }.min
    return score

    loop do
    end


    gScore
      .map do |node, cost|
        next unless node.first == goal

        current = node
        total_path = [current]

        loop do
          current = cameFrom[current]
          break unless current
          total_path.unshift(current)
        end

        cost = 0
        last_direction = total_path.shift.last

        total_path.each do |_, direction|
          cost += direction == last_direction ? 1 : 1001
          last_direction = direction
        end

        cost
      end
      .compact
      .min
  end

  private

  def h(node, goal)
    (nx, ny), _ = node
    gx, gy = goal
    (gy - ny) ** 2 + (gx - nx) ** 2
  end
end
