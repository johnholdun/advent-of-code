class Response
  DIRECTIONS = [-1, 0, 1].map { |dx| [-1, 0, 1].map { |dy| [dx, dy] } }.flatten(1) - [[0, 0]]

  def call(input)
    grid = input.map { |l| l.split('') }
    cols = grid.first.size
    rows = grid.size

    (rows * cols).times.map do |n|
      x = n % cols
      y = (n / rows.to_f).floor

      DIRECTIONS.count do |(dx, dy)|
        %w(X M A S).each_with_index.all? do |l, i|
          x2 = x + dx * i
          y2 = y + dy * i

          x2 >= 0 &&
            x2 < grid.first.size &&
            y2 >= 0 &&
            y2 < grid.size &&
            grid[y2][x2] == l
        end
      end
    end.sum
  end
end
