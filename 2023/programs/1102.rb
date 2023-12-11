class Response
  def call(lines)
    galaxies = []

    lines.each_with_index do |line, y|
      line.split('').each_with_index do |char, x|
        galaxies.push([x, y]) if char == '#'
      end
    end

    rows = lines.size
    columns = lines.first.size

    empty_rows = rows.times.select { |y| galaxies.none? { |_, y2| y2 == y } }
    empty_columns = columns.times.select { |x| galaxies.none? { |x2, _| x2 == x } }

    galaxies.map! do |x, y|
      [
        x + 999999 * empty_columns.count { |x2| x2 < x },
        y + 999999 * empty_rows.count { |y2| y2 < y }
      ]
    end

    sum = 0

    galaxies.each_with_index do |(x1, y1), i1|
      galaxies.each_with_index do |(x2, y2), i2|
        next if i2 <= i1
        sum += (x1 - x2).abs + (y1 - y2).abs
      end
    end

    sum
  end
end
