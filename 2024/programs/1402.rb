class Response
  def call(input)
    robots = input.map { |l| l.scan(/-?\d+/).to_a.map(&:to_i) }
    width = 101
    height = 103
    step = 0

    loop do
      step_result = max_contiguous(robots)
      if step_result > 100
        height.times do |y|
          width.times do |x|
            if robots.any? { |rx, ry, _, _| rx == x && ry == y }
              print '#'
            else
              print ' '
            end
          end
          puts
        end

        return step
      end

      robots.each_with_index do |(x, y, vx, vy), i|
        robots[i] = [(x + vx) % width, (y + vy) % height, vx, vy]
      end

      step += 1
    end
  end

  private

  def max_contiguous(robots)
    result = 1
    points = robots.map { |x, y, _, _| [[x, y], true] }.to_h
    seen = {}
    robots.each do |x, y, _, _|
      next if seen[[x, y]]
      seen[[x, y]] = true

      this_area = [[x, y]]
      size = 1

      loop do
        break if this_area.empty?
        tx, ty = this_area.shift

        [[0, -1], [0, 1], [-1, 0], [1, 0]].each do |dx, dy|
          x2 = tx + dx
          y2 = ty + dy
          next unless points[[x2, y2]]
          next if seen[[x2, y2]]
          seen[[x2, y2]] = true
          this_area.push([x2, y2])
          size += 1
        end
      end

      result = [result, size].max
    end

    result
  end
end
