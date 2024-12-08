require 'set'

class Response
  def call(input)
    antennae = {}
    rows = input.size
    cols = input.first.size

    input.each_with_index do |line, y|
      line.split('').each_with_index do |char, x|
        next if char == '.'
        antennae[char] ||= []
        antennae[char].push([x, y])
      end
    end

    antinodes = Set.new(antennae.values.select { |v| v.size > 1 }.flatten(1))

    antennae.each do |char, positions|
      positions.each_with_index do |p1, index|
        positions[index + 1..].each do |p2|
          dx = p1[0] - p2[0]
          dy = p1[1] - p2[1]

          [[p1, 1], [p2, -1]].each do |(x, y), mult|
            loop do
              x += dx * mult
              y += dy * mult
              break unless (0...cols).include?(x) && (0...rows).include?(y)
              antinodes.add([x, y])
            end
          end
        end
      end
    end

    antinodes.size
  end
end
