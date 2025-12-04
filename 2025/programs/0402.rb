class Response
  def call(input)
    cells = input.map { |row| row.split('').map { |c| c == '@' } }
    removed = 0
    loop do
      new_removed, new_cells = lift(cells)
      break if new_removed.zero?
      removed += new_removed
      cells = new_cells
    end

    removed
  end

  private

  def lift(cells)
    new_cells = cells.map(&:dup)
    rows = cells.size
    cols = cells.first.size
    count = 0

    cells.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        next unless cell
        neighbors = 0

        [-1, 0, 1].each do |dx|
          [-1, 0, 1].each do |dy|
            next if dx.zero? && dy.zero?
            x2 = x + dx
            y2 = y + dy

            neighbors += 1 if x2 >= 0 && x2 <= cols - 1 && y2 >= 0 && y2 <= rows - 1 && cells[y2][x2]
          end
        end

        if neighbors < 4
          count += 1
          new_cells[y][x] = false
        end
      end
    end

    [count, new_cells]
  end
end
