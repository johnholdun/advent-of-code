class Response
  DIRECTIONS = {
    'U' => [0, 1],
    'D' => [0, -1],
    'L' => [-1, 0],
    'R' => [1, 0]
  }.freeze

  def call(input)
    points = {}
    hx = 0
    hy = 0
    tx = 0
    ty = 0
    points[[tx, ty]] = true

    input.each do |line|
      dir, times = line.split(' ')
      dx, dy = DIRECTIONS[dir]
      times.to_i.times do
        hx += dx
        hy += dy

        if (hx - tx).abs == 2 && hy == ty
          tx += tx > hx ? -1 : 1
        elsif (hy - ty).abs == 2 && hx == tx
          ty += ty > hy ? -1 : 1
        elsif (hy - ty).abs + (hx - tx).abs > 2
          tx += tx > hx ? -1 : 1
          ty += ty > hy ? -1 : 1
        end

        points[[tx, ty]] = true
      end
    end

    points.keys.size
  end
end
