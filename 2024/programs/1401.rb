class Response
  def call(input)
    robots = input.map { |l| l.scan(/-?\d+/).to_a.map(&:to_i) }
    width = 101
    height = 103

    100.times do
      robots.each_with_index do |(x, y, vx, vy), i|
        x2 = (x + vx) % width
        y2 = (y + vy) % height
        robots[i] = [x2, y2, vx, vy]
      end
    end

    quadrants = [0, 0, 0, 0]

    cx = (width / 2).ceil
    cy = (height / 2).ceil

    robots.each do |x, y, _, _|
      next if x == cx || y == cy
      qx = x < cx ? 0 : 1
      qy = y < cy ? 0 : 1
      i = qx + qy * 2
      quadrants[i] += 1
    end

    quadrants.reduce(:*)
  end
end
