class Response
  def call(input)
    input.count do |line|
      levels = line.split(' ').map(&:to_i)
      safe?(levels) || double_safe?(levels)
    end
  end

  private

  def safe?(levels)
    return safe?(levels.reverse) if levels.last < levels.first
    levels = levels.dup

    loop do
      head = levels.shift
      return true if levels.empty?
      return false unless (1..3).include?(levels.first - head)
    end
  end

  def double_safe?(levels)
    levels.size.times.find do |i|
      safe?(levels.each_with_index.select { |_, i2| i2 != i }.map(&:first))
    end
  end
end
