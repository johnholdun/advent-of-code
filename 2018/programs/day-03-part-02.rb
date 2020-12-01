require './day'

class Day3Part2 < Day
  DAY = 3
  PART = 2

  def call
    inches = {}

    input.each do |line|
      claim = parse_claim(line)
      claim[:width].times do |dx|
        claim[:height].times do |dy|
          key = [claim[:x] + dx, claim[:y] + dy]
          inches[key] ||= []
          inches[key].push(claim[:id])
        end
      end
    end

    claim_neighbors = Hash.new(0)

    inches.values.each do |ids|
      unique_ids = ids.uniq
      unique_ids.each do |id|
        claim_neighbors[id] = [unique_ids.size, claim_neighbors[id]].max
      end
    end

    claim_neighbors.to_a.find { |_, neighbors| neighbors == 1 }[0]
  end

  private

  def parse_claim(input)
    match = input.scan(/^#(.+) @ (\d+),(\d+): (\d+)x(\d+)$/)[0]

    {
      id: match[0].to_i,
      x: match[1].to_i,
      y: match[2].to_i,
      width: match[3].to_i,
      height: match[4].to_i
    }
  end
end
