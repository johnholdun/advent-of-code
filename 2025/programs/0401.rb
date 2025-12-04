class Response
  def call(input)
    cells = input.map { |row| row.split('').map { |c| c == '@' } }
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

        count += 1 if neighbors < 4
      end
    end

    count
  end
end
