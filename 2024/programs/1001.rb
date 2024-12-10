class Response
  def call(input)
    @grid = input.map { |row| row.split('').map(&:to_i) }
    @rows = grid.size
    @cols = grid.first.size

    @trailheads = {}

    grid.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        walk([x, y], [x, y], 8) if cell == 9
      end
    end

    trailheads.values.map(&:size).sum
  end

  private

  attr_reader :grid, :rows, :cols, :trailheads

  def walk(start, position, target_points)
    if target_points == -1
      @trailheads[position] ||= Set.new
      @trailheads[position].add(start)
    end

    [[-1, 0], [1, 0], [0, -1], [0, 1]].map do |dx, dy|
      x, y = position
      x += dx
      y += dy

      if (0...rows).include?(y) && (0...cols).include?(x) && grid[y][x] == target_points
        walk(start, [x, y], target_points - 1)
      end
    end.compact
  end
end
