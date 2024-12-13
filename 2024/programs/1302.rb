class Response
  def call(input)
    games =
      input
        .each_slice(4)
        .map do |a, b, prize|
          a = a.scan(/Button A: X\+(\d+), Y\+(\d+)/).to_a.flatten.map(&:to_i)
          b = b.scan(/Button B: X\+(\d+), Y\+(\d+)/).to_a.flatten.map(&:to_i)
          prize = prize.scan(/Prize: X=(\d+), Y=(\d+)/).to_a.flatten.map(&:to_i)
          [a, b, prize]
        end

    games.map { |(ax, ay), (bx, by), (px, py)| cost(ax, ay, bx, by, px + 10000000000000, py + 10000000000000) }.compact.sum
  end

  private

  def cost(ax, ay, bx, by, px, py)
    # a * ax + b * bx = px
    # a * ax = px - (b * bx)
    # a = (px - b * bx) / ax

    # a * ay + b * by = py
    # somehow it seems i can replace a in this function and simplify down to the
    # following lol
    # i probably learned how to do this in high school

    b = (py * ax - px * ay) / (by * ax - bx * ay)
    a = (px - b * bx) / ax

    if a * ax + b * bx == px && a * ay + b * by == py
      3 * a + b
    end
  end
end
