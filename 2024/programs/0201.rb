class Response
  def call(input)
    input.count { |l| safe?(l.split(' ').map(&:to_i)) }
  end

  private

  def safe?(levels)
    head = levels.shift
    direction = levels.first > head ? 1 : -1
    range = (1..3).map { |n| n * direction }.to_a

    loop do
      return true if levels.empty?
      return false unless range.include?(levels.first - head)
      head = levels.shift
    end
  end
end
