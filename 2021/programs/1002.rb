class Response
  PAIRS = [
    ['(', ')', 1],
    ['[', ']', 2],
    ['{', '}', 3],
    ['<', '>', 4]
  ].freeze

  OPENERS = PAIRS.map(&:first).freeze
  CLOSERS = PAIRS.map { |p| p.take(2).reverse }.to_h.freeze
  CLOSERS_OPENERS = CLOSERS.to_a.map(&:reverse).to_h.freeze
  SCORES = PAIRS.map { |p| p[1, 2] }.to_h.freeze

  def call(input)
    pointses = input.map { |i| points(i) }.reject(&:zero?)
    pointses.sort[pointses.size / 2]
  end

  private

  def points(line)
    open_pairs = []

    line.split('').each_with_index do |char, index|
      if OPENERS.include?(char)
        open_pairs.push(char)
      elsif CLOSERS[char] == open_pairs.last
        open_pairs.pop
      else
        return 0
      end
    end

    closers = open_pairs.reverse.map { |c| SCORES[CLOSERS_OPENERS[c]] }
    score = 0
    closers.each do |closer|
      score = score * 5 + closer
    end
    score
  end
end
