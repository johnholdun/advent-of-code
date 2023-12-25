class Response
  def call(input)
    machines = Hash.new { |h, k| h[k] = [] }

    input.each do |line|
      left, rest = line.split(': ')
      right = rest.split(' ')
      machines[left] += right
      right.each { |r| machines[r].push(left) }
    end

    vertices = []
    machines.each do |left, rights|
      rights.each do |right|
        vertex = [left, right].sort
        vertices.push(vertex) unless vertices.include?(vertex)
      end
    end

    wires_to_delete = []
    source_vertices = vertices.map(&:dup)

    loop do
      vertices = source_vertices.map(&:dup).each_with_index.to_a.shuffle
      result = []

      loop do
        keep, remove, original = vertices.sample.flatten

        vertices_to_delete = []

        vertices.each_with_index do |((left, right), original_index), index|
          if left == remove
            vertices[index][0][0] = keep
            vertices_to_delete.push(index) if right == keep
          elsif right == remove
            vertices[index][0][1] = keep
            vertices_to_delete.push(index) if left == keep
          end
        end

        vertices_to_delete.reverse.each do |index|
          vertices.delete_at(index)
        end

        remaining_machines = vertices.flat_map(&:first).uniq
        break if remaining_machines.size <= 2
      end

      puts "hm: #{vertices.size}"

      if vertices.size == 3
        wires_to_delete = vertices.map { |_, i| source_vertices[i] }
        break
      end
    end

    puts wires_to_delete.inspect
    wires = source_vertices - wires_to_delete
    first_group = wires.first.dup
    second_group = wires.flatten.uniq - wires.first

    loop do
      changes = 0

      first_group.each do |machine|
        machine_wires = wires.select { |w| w.include?(machine) }.flatten.uniq - [machine]
        connected_machines = second_group.select { |m| machine_wires.include?(m) }
        if connected_machines.size > 0
          changes += 1
          second_group -= connected_machines
          first_group += connected_machines
        end
      end

      break if changes.zero?
    end

    first_group.size * second_group.size

  #   1)  Initialize contracted graph CG as copy of original graph
  #   2)  While there are more than 2 vertices.
  #         a) Pick a random edge (u, v) in the contracted graph.
  #         b) Merge (or contract) u and v into a single vertex (update
  #            the contracted graph).
  #         c) Remove self-loops
  #   3) Return cut represented by two vertices.
  end
end
