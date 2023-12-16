class Response
  DIRECTIONS = %i(right left up down).freeze

  def call(lines)
    @field = {}

    lines.each_with_index do |line, y|
      line.chars.each_with_index do |char, x|
        @field[[x, y]] = char unless char == '.'
      end
    end

    @width = lines.first.size
    @height = lines.size

    max_energy = 0

    tries = []
    tries += width.times.map { |x| [x, 0, :down] }
    tries += width.times.map { |x| [x, height - 1, :up] }
    tries += height.times.map { |y| [0, y, :right] }
    tries += height.times.map { |y| [width - 1, y, :left] }

    tries.each do |head|
      max_energy = [max_energy, energies(head)].max
    end

    max_energy
  end

  private

  attr_reader :field, :width, :height

  def energies(head)
    result = {}
    heads = [head]
    seen = {}

    loop do
      break if heads.size.zero?

      x, y, dir = heads.shift

      seen_key = y * height + x + (DIRECTIONS.index(dir) * width * height)
      next if seen[seen_key]
      seen[seen_key] = true

      result[y * width + x] = true

      new_dirs =
        case field[[x, y]]
        when '/'
          new_dir =
            case dir
            when :right then :up
            when :left then :down
            when :up then :right
            when :down then :left
            end

          [new_dir]
        when '\\'
          new_dir =
            case dir
            when :right then :down
            when :left then :up
            when :up then :left
            when :down then :right
            end

          [new_dir]
        when '-'
          case dir
          when :left, :right
            [dir]
          else
            [:left, :right]
          end
        when '|'
          case dir
          when :up, :down
            [dir]
          else
            [:up, :down]
          end
        else
          [dir]
        end

      new_dirs.each do |new_dir|
        new_x, new_y =
          case new_dir
          when :up
            [x, y - 1]
          when :down
            [x, y + 1]
          when :left
            [x - 1, y]
          when :right
            [x + 1, y]
          end

        if new_x >= 0 && new_x < width && new_y >= 0 && new_y < height
          heads.push([new_x, new_y, new_dir])
        end
      end
    end

    result.size
  end
end
