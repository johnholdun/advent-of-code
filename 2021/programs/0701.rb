class Response
  def call(input)
    positions = input.first.split(',').map(&:to_i)
    (positions.min..positions.max).map do |target|
      positions.map { |p| (target - p).abs }.inject(:+)
    end.min
  end
end
