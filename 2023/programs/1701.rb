# Heavily inspired by this solution, thank you:
# https://www.reddit.com/r/adventofcode/comments/18k9ne5/comment/kglbfuc/
class Response
  DELTAS = {
    'L' => [-1, 0],
    'R' => [1, 0],
    'U' => [0, -1],
    'D' => [0, 1]
  }.freeze

  REVERSALS = {
    'L' => 'R',
    'R' => 'L',
    'U' => 'D',
    'D' => 'U'
  }.freeze

  def call(lines)
    rows = lines.size
    columns = lines.first.size
    grid = lines.map { |l| l.split('').map(&:to_i) }

    goal = [columns - 1, rows - 1]

    max_consecutive = 3

    states = {}
    @queue = {}

    # x, y, dir, consecutive, cost

    push \
      [0, 0, 'D', 0, 0],
      0

    push \
      [0, 0, 'R', 0, 0],
      0

    while present?
      x, y, dir, consecutive, cost = pop

      state_key = [x, y, dir, consecutive].join(' ')
      next if states[state_key]
      states[state_key] = true

      DELTAS.each do |f, (dx, dy)|
        next if f == REVERSALS[dir]

        x2 = x + dx
        y2 = y + dy

        next unless grid[y2] && grid[y2][x2]
        next_cost = cost + grid[y2][x2]

        next if f == dir && consecutive >= max_consecutive
        next_consecutive = f == dir ? consecutive + 1 : 1

        return next_cost if x2 == goal[0] && y2 == goal[1]

        push \
          [x2, y2, f, next_consecutive, next_cost],
          next_cost
      end
    end

    # 1247 too low??
  end

  def present?
    @queue.keys.size > 0
  end

  def pop
    key = @queue.keys.min
    item = @queue[key].pop
    @queue.delete(key) if @queue[key].size.zero?
    item
  end

  def push(item, key)
    @queue[key] ||= []
    @queue[key].push(item)
  end
end
