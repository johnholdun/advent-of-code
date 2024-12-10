class Response
  def call(input)
    @grid = input.map { |row| row.split('').map(&:to_i) }
    @rows = grid.size
    @cols = grid.first.size

    @trailheads = {}

    grid.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        walk([[x, y]]) if cell == 9
      end
    end

    trailheads.values.map(&:size).sum
  end

  private

  attr_reader :grid, :rows, :cols, :trailheads

  def walk(path)
    if path.size == 10
      @trailheads[path.last] ||= Set.new
      @trailheads[path.last].add(path.reverse)
    end

    target_points = 9 - path.size

    [[-1, 0], [1, 0], [0, -1], [0, 1]].map do |dx, dy|
      x, y = path.last
      x += dx
      y += dy

      if (0...rows).include?(y) && (0...cols).include?(x) && grid[y][x] == target_points
        walk(path + [[x, y]])
      end
    end.compact
  end
end
