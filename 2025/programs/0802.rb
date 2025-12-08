class Response
  def call(input)
    boxes = input.map { |i| i.split(',').map(&:to_i) }
    distances = {}

    boxes.each_with_index do |a, ia|
      (ia + 1...boxes.size).each do |ib|
        b = boxes[ib]

        distance = [0, 1, 2].map { |n| (a[n] - b[n]) ** 2 }.sum
        raise "i did not expect this" if distances.key?(distance)
        distances[distance] = [ia, ib]
      end
    end

    sorted_pairs = distances.keys.sort.map { |d| distances[d] }

    groups = sorted_pairs[0, 1000].map { |pair| Set.new(pair) }

    boxes.size.times do |i|
      unless groups.any? { |g| g.include?(i) }
        groups.push(Set.new([i]))
      end
    end

    groups = combine_groups(groups)

    sorted_pairs[1000..].each do |a, b|
      groups = combine_groups(groups + [Set.new([a, b])])

      if groups.size == 1
        return boxes[a][0] * boxes[b][0]
      end
    end

    raise "uh oh"
  end

  private

  def combine_groups(input_groups)
    groups = input_groups.map(&:dup)

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

    groups
  end
end
