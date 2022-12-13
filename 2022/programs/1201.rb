class Response
  DIRECTIONS = [
    [0, 1],
    [0, -1],
    [-1, 0],
    [1, 0]
  ].freeze

  def call(input)
    origin = nil
    destination = nil

    grid =
      input.each_with_index.map do |line, y|
        line.split('').each_with_index.map do |character, x|
          this_key = key(x, y)

          height =
            case character
            when 'S'
              origin = this_key
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
              neighbors: [],
              distance: Float::INFINITY
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

    checks = [origin]
    distance = 0

    loop do
      checks.each do |key|
        grid[key][:distance] = [grid[key][:distance], distance].min
      end
      break if checks.include?(destination)
      distance += 1
      checks =
        checks
          .flat_map { |k| grid[k][:neighbors] }
          .uniq
          .select { |k| grid[k][:distance] > distance }
      break if checks.size.zero?
    end

    grid[destination][:distance]
  end

  private

  def key(x, y)
    "#{x},#{y}"
  end
end
