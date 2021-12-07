class Response
  def call(input)
    positions = input.first.split(',').map(&:to_i)
    (positions.min..positions.max).map do |target|
      positions.map { |p| distance((target - p).abs) }.inject(:+)
    end.min
  end

  private

  def distance(n)
    @distances ||= {}
    @distances[n] ||= n == 0 ? 0 : distance(n - 1) + n
  end
end
