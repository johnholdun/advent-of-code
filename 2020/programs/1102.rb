class Response
  def call(input)
    @input = input
    old_occupancies = []

    loop do
      new_occupancies = []

      seats.each do |id, seat|
        occupied = old_occupancies.include?(id)
        occupied_neighbors = occupied_neighbor_count(id, old_occupancies)

        if occupied && occupied_neighbors < 5 || !occupied && occupied_neighbors == 0
          new_occupancies.push(id)
        end
      end

      break if new_occupancies == old_occupancies
      old_occupancies = new_occupancies
    end

    old_occupancies.size
  end

  private

  def seats
    @seats ||=
      @input.each_with_index.map do |line, y|
        line.split('').each_with_index.map do |char, x|
          next if char == '.'
          id = "#{x},#{y}"
          [id, { id: id, x: x, y: y }]
        end
      end
      .flatten(1)
      .compact
      .to_h
  end

  def bounds
    @bounds ||=
      {
        x: (0..seats.values.map { |s| s[:x] }.max),
        y: (0..seats.values.map { |s| s[:y] }.max)
      }
  end

  def neighbors
    @neighbors ||=
      seats.each_with_object({}) do |(id, seat), obj|
        neighbs = []

        [-1, 0, 1].each do |dx|
          [-1, 0, 1].each do |dy|
            next if dx == 0 && dy == 0
            x = seat[:x]
            y = seat[:y]
            loop do
              x += dx
              y += dy
              unless bounds[:x].include?(x) && bounds[:y].include?(y)
                break
              end
              nid = seats.dig("#{x},#{y}", :id)
              if nid
                neighbs.push(nid)
                break
              end
            end
          end
        end

        obj[id] = neighbs
      end
  end

  def occupied_neighbor_count(id, old_occupancies)
    neighbors[id].count do |nid|
      old_occupancies.include?(nid)
    end
  end
end
