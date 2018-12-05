require './day'

class Day3Part1 < Day
  DAY = 3
  PART = 1

  def call
    inches = Hash.new(0)

    input.each do |line|
      claim = parse_claim(line)
      claim[:width].times do |dx|
        claim[:height].times do |dy|
          inches[[claim[:x] + dx, claim[:y] + dy]] += 1
        end
      end
    end

    inches.select { |_, times| times > 1 }.size
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
