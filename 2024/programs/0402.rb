class Response
  def call(input)
    grid = input.map { |l| l.split('') }
    cols = grid.first.size
    rows = grid.size

    (rows * cols).times.count do |n|
      x = n % cols
      y = (n / rows.to_f).floor

      c = at(grid, x, y)

      next unless c == 'A'

      nw = at(grid, x - 1, y - 1)
      ne = at(grid, x + 1, y - 1)
      sw = at(grid, x - 1, y + 1)
      se = at(grid, x + 1, y + 1)

      next unless nw && ne && sw && se

      %w(M S) == [nw, se].sort && %w(M S) == [sw, ne].sort
    end
  end

  private

  def at(grid, x, y)
    return nil unless y >= 0 && grid[y]
    return nil unless x >= 0
    grid[y][x]
  end
end
