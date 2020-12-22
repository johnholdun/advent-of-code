class Response
  def call(input)
    seats =
      input.each_with_index.map do |line, y|
        line.split('').each_with_index.map do |char, x|
          next if char == '.'
          id = "#{x},#{y}"
          [id, { id: id, x: x, y: y }]
        end
      end
      .flatten(1)
      .compact
      .to_h

    neighbors =
      seats.map do |id, seat|
        neighbs =
          [-1, 0, 1].map do |dx|
            [-1, 0, 1].map do |dy|
              next if dx == 0 && dy == 0
              seats.dig("#{seat[:x] + dx},#{seat[:y] + dy}", :id)
            end
          end
          .flatten
          .compact

        [id, neighbs]
      end.to_h

    old_occupancies = []

    loop do
      new_occupancies = []

      seats.each do |id, seat|
        occupied = old_occupancies.include?(id)
        occupied_neighbors =
          neighbors[id].count { |nid| old_occupancies.include?(nid) }

        if occupied && occupied_neighbors < 4 || !occupied && occupied_neighbors == 0
          new_occupancies.push(id)
        end
      end

      break if new_occupancies == old_occupancies
      old_occupancies = new_occupancies
    end

    old_occupancies.size
  end
end
