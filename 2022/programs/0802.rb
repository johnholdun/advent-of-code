class Response
  def call(input)
    trees =
      input.each_with_index.map do |row, y|
        row.split('').each_with_index.map do |height, x|
          [[x, y], height.to_i]
        end
      end.flatten(1)
      .to_h

    trees
      .map do |(x, y), height|
        [[0, -1], [0, 1], [-1, 0], [1, 0]]
          .map do |(dx, dy)|
            count = 0
            x2 = x + dx
            y2 = y + dy

            loop do
              next_height = trees[[x2, y2]]
              break unless next_height

              count += 1
              break if next_height >= height

              x2 += dx
              y2 += dy
            end

            count
          end
          .reduce(:*)
      end
      .max
  end
end
