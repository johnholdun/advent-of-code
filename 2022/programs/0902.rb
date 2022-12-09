class Response
  DIRECTIONS = {
    'U' => [0, 1],
    'D' => [0, -1],
    'L' => [-1, 0],
    'R' => [1, 0]
  }.freeze

  def call(input)
    steps = expand(input)
    9.times do
      steps = follow(steps)
    end
    steps.uniq.size
  end

  private

  def expand(input)
    steps = [[0, 0]]
    input.each do |line|
      dir, times = line.split(' ')
      dx, dy = DIRECTIONS[dir]
      times.to_i.times do
        x, y = steps.last
        x += dx
        y += dy
        steps.push([x, y])
      end
    end
    steps
  end

  def follow(steps)
    result = [steps[0]]

    steps.each do |hx, hy|
      tx, ty = result.last
      if (hx - tx).abs == 2 && hy == ty
        tx += tx > hx ? -1 : 1
      elsif (hy - ty).abs == 2 && hx == tx
        ty += ty > hy ? -1 : 1
      elsif (hy - ty).abs + (hx - tx).abs > 2
        tx += tx > hx ? -1 : 1
        ty += ty > hy ? -1 : 1
      end
      result.push([tx, ty])
    end

    result
  end
end
