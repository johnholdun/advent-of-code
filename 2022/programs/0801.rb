class Response
  def call(input)
    trees = {}
    cols = 0
    rows = 0

    input.each_with_index do |row, y|
      row.split('').each_with_index do |height, x|
        cols = [cols, x].max
        rows = [rows, y].max
        trees[[x, y]] = height.to_i
      end
    end

    trees.count do |(x, y), height|
      x == 0 ||
      x == cols ||
      y == 0 ||
      y == rows ||
      (0...x).all? { |x2| trees[[x2, y]] < height } ||
      ((x + 1)..cols).all? { |x2| trees[[x2, y]] < height } ||
      (0...y).all? { |y2| trees[[x, y2]] < height } ||
      ((y + 1)..rows).all? { |y2| trees[[x, y2]] < height }
    end
  end
end
