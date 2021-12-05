class Response
  def call(input)
    segments =
      input.map do |line|
        line
          .scan(/^(\d+),(\d+) -> (\d+),(\d+)$/)
          .first
          .map(&:to_i)
      end

    hits = Hash.new(0)

    segments.each do |(x1, y1, x2, y2)|
      if x1 == x2
        Range.new(*[y1, y2].sort).each do |y|
          hits[[x1, y]] += 1
        end
      elsif y1 == y2
        Range.new(*[x1, x2].sort).each do |x|
          hits[[x, y1]] += 1
        end
      else
        dx = x2 > x1 ? 1 : -1
        dy = y2 > y1 ? 1 : -1

        Range.new(*[x1, x2].sort).size.times do |i|
          hits[[x1 + dx * i, y1 + dy * i]] += 1
        end
      end
    end

    hits.values.count { |v| v >= 2 }
  end
end
