class Response
  PAIRS = [
    ['(', ')', 3],
    ['[', ']', 57],
    ['{', '}', 1197],
    ['<', '>', 25137]
  ].freeze

  OPENERS = PAIRS.map(&:first).freeze
  CLOSERS = PAIRS.map { |p| p.take(2).reverse }.to_h.freeze
  SCORES = PAIRS.map { |p| p[1, 2] }.to_h.freeze

  def call(input)
    input.map { |i| points(i) }.inject(:+)
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
        return SCORES[char]
      end
    end

    0
  end
end
