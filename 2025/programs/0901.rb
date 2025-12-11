class Response
  def call(input)
    pairs = input.map { |l| l.split(',').map(&:to_i) }
    biggest = 0

    pairs.each_with_index do |(x1, y1), i|
      (i + 1...pairs.size).each do |i2|
        x2, y2 = pairs[i2]
        area = ((x2 - x1).abs + 1) * ((y2 - y1).abs + 1)
        biggest = [area, biggest].max
      end
    end

    biggest
  end
end
