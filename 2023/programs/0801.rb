class Response
  def call(lines)
    steps = lines.shift.split('').map { |s| s == 'L' ? 0 : 1 }
    lines.shift

    nodes =
      lines
        .map do |line|
          node, left, right = line.scan(/^(.{3}) = \((.{3}), (.{3})\)/).flatten
          [node, [left, right]]
        end
        .to_h

    node = 'AAA'
    step = 0

    while node != 'ZZZ'
      node = nodes[node][steps[step % steps.size]]
      step += 1
    end

    step
  end
end
