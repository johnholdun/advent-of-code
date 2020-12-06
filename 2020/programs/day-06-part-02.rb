require './day'

class Day6Part2 < Day
  DAY = 6
  PART = 2

  def call
    input.join("\n").split(/\n{2,}/).map do |answers|
      responses = answers.lines.map { |a| a.scan(/[a-z]/) }
      responses.flatten.uniq.count do |answer|
        responses.all? { |r| r.include?(answer) }
      end
    end.sum
  end
end
