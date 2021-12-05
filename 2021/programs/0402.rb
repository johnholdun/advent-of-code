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

    last_winner = nil
    last_call = nil

    calls.each do |call|
      boards.map! do |lines|
        lines.map! do |line|
          line.map! do |number|
            number == call ? nil : number
          end
        end
      end

      called_winners = winners

      if called_winners.size > 0
        last_winner = called_winners.first
        last_call = call
        boards.reject! { |b| called_winners.include?(b) }
      end
    end

    last_winner.flatten.compact.inject(:+).to_i * last_call
  end

  private

  attr_reader :boards

  def winners
    boards.select do |lines|
      next true if lines.any? { |l| l.all?(&:nil?) }
      5.times.any? do |column|
        lines.all? { |l| l[column].nil? }
      end
    end
  end
end
