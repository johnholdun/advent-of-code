require 'set'

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

    current_nodes = nodes.keys.select { |n| n =~ /A$/ }
    node_steps = []

    current_nodes.each do |node|
      step = 0
      while node !~ /Z$/
        node = nodes[node][steps[step % steps.size]]
        step += 1
      end
      node_steps.push(step)
    end

    # i started writing a function to calculate least common multiple while
    # the version of a naïf was running, and it finished looping before the
    # aforementioned naïf had finished reading the geeks for geeks dot org
    # explanation, so…bye

    lcm = node_steps.max

    while node_steps.any? { |s| (lcm / s.to_f).floor != (lcm / s.to_f).ceil }
      lcm += node_steps.max
    end

    lcm
  end
end
