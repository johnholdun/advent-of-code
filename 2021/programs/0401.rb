class Response
  def call(input)
    calls = input.shift.split(',').map(&:to_i)
    @boards = []

    input.each do |line|
      if line == ''
        boards.push([])
        next
      end

      boards.last.push(line.strip.split(/\s+/).map(&:to_i))
    end

    calls.each do |call|
      boards.map! do |lines|
        lines.map! do |line|
          line.map! do |number|
            number == call ? nil : number
          end
        end
      end

      called_winner = winner

      if called_winner
        return called_winner.flatten.compact.inject(:+) * call
      end
    end
  end

  private

  attr_reader :boards

  def winner
    boards.find do |lines|
      next true if lines.any? { |l| l.all?(&:nil?) }
      5.times.any? do |column|
        lines.all? { |l| l[column].nil? }
      end
    end
  end
end
