class Turn
  CODES =
    {
      'A' => :rock,
      'B' => :paper,
      'C' => :scissors,
      'X' => :lose,
      'Y' => :draw,
      'Z' => :win
    }.freeze

  VICTORIES =
    {
      rock: :scissors,
      paper: :rock,
      scissors: :paper
    }.freeze

  DEFEATS = VICTORIES.map(&:reverse).to_h.freeze

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
    @them, @outcome = line.split(' ').map { |i| CODES[i] }
  end

  def me
    case outcome
    when :draw then them
    when :win then DEFEATS[them]
    else VICTORIES[them]
    end
  end

  def score
    POINTS[outcome] + POINTS[me]
  end

  private

  attr_reader :them, :outcome
end

class Response
  def call(input)
    turns = input.map { |i| Turn.new(i) }
    turns.map(&:score).sum
  end
end
