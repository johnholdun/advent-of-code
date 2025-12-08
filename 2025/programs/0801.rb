class Response
  def call(input)
    boxes = input.map { |i| i.split(',').map(&:to_i) }
    distances = {}

    boxes.each_with_index do |a, ia|
      (ia + 1...boxes.size).each do |ib|
        b = boxes[ib]

        distance = [0, 1, 2].map { |n| (a[n] - b[n]) ** 2 }.sum
        distances[distance] ||= []
        distances[distance].push([ia, ib])
      end
    end

    groups = distances.keys.sort[0, 1000].map { |k| Set.new(distances[k].first) }

    boxes.size.times do |i|
      unless groups.any? { |g| g.include?(i) }
        groups.push(Set.new([i]))
      end
    end

    loop do
      new_groups = []

      groups.each do |group|
        found = false

        new_groups.each_with_index do |new_group, index|
          if new_group.intersect?(group)
            found = true
            new_groups[index] = new_group + group
            break
          end
        end

        new_groups.push(group) unless found
      end

      break if new_groups == groups
      groups = new_groups
    end

    groups.map(&:size).sort[-3, 3].inject(:*)
  end
end
