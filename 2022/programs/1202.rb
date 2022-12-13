class Response
  DIRECTIONS = [
    [0, 1],
    [0, -1],
    [-1, 0],
    [1, 0]
  ].freeze

  def call(input)
    destination = nil

    grid =
      input.each_with_index.map do |line, y|
        line.split('').each_with_index.map do |character, x|
          this_key = key(x, y)

          height =
            case character
            when 'S'
              0
            when 'E'
              destination = this_key
              25
            else
              character.ord - 97
            end

          [
            this_key,
            {
              position: [x, y],
              key: this_key,
              height: height,
              neighbors: []
            }
          ]
        end
      end.flatten(1).to_h

    grid.each do |key, params|
      params[:neighbors] =
        DIRECTIONS
          .map { |dx, dy| key(params[:position][0] + dx, params[:position][1] + dy) }
          .select { |key| grid.key?(key) && grid[key][:height] <= params[:height] + 1 }
    end

    least = Float::INFINITY

    grid.values.select { |v| v[:height].zero? }.map { |v| v[:key] }.each do |origin|
      distances = Hash.new { |k, v| Float::INFINITY }
      checks = [origin]
      distance = 0

      loop do
        checks.each do |key|
          distances[key] = [distances[key], distance].min
        end
        break if checks.include?(destination)
        distance += 1
        checks =
          checks
            .flat_map { |k| grid[k][:neighbors] }
            .uniq
            .select { |k| distances[k] > distance }
        break if checks.size.zero?
      end

      least = [least, distances[destination]].min
    end

    least
  end

  private

  def key(x, y)
    "#{x},#{y}"
  end
end
