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

    antinodes = Set.new

    antennae.each do |char, positions|
      positions.each_with_index do |p1, index|
        # next if index == positions.size - 1

        positions[index + 1..positions.size].each do |p2|
          dx = p1[0] - p2[0]
          dy = p1[1] - p2[1]

          antinodes.add([p1[0] + dx, p1[1] + dy])
          antinodes.add([p2[0] - dx, p2[1] - dy])
        end
      end
    end

    antinodes.count do |x, y|
      (0...cols).include?(x) && (0...rows).include?(y)
    end
  end
end
