class Response
  def call(input)
    positions = []
    positions.push(input.shift.split(' ').last.to_i)
    positions.push(input.shift.split(' ').last.to_i)
    scores = [0, 0]
    @roll = 0
    @player = 0
    rolls = 0
    loop do
      move = 3.times.map { roll }.inject(:+)
      rolls += 3
      positions[@player] = ((positions[@player] - 1 + move) % 10) + 1
      scores[@player] += positions[@player]
      break if scores[@player] >= 1000
      @player = (@player + 1) % 2
    end

    loser = (@player + 1) % 2
    scores[loser] * rolls
  end

  private

  def roll
    @roll = (@roll + 1) % 100
  end
end
