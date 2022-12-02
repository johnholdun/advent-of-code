class Turn
  TURNS =
    {
      'A' => :rock,
      'B' => :paper,
      'C' => :scissors,
      'X' => :rock,
      'Y' => :paper,
      'Z' => :scissors
    }.freeze

  VICTORIES =
    {
      rock: :scissors,
      paper: :rock,
      scissors: :paper
    }.freeze

  POINTS =
    {
      rock: 1,
      paper: 2,
      scissors: 3,
      win: 6,
      lose: 0,
      draw: 3
    }

  def initialize(line)
    @them, @me = line.split(' ').map { |i| TURNS[i] }
  end

  def outcome
    return :draw if me == them
    return :win if VICTORIES[me] == them
    return :lose
  end

  def score
    POINTS[outcome] + POINTS[me]
  end

  private

  attr_reader :them, :me
end

class Response
  def call(input)
    turns = input.map { |i| Turn.new(i) }
    turns.map(&:score).sum
  end
end
