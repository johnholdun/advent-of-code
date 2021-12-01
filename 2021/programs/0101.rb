class Response
  def call(input)
    depths = input.map(&:to_i)
    depths.each_with_index.count do |val, n|
      n > 0 && val > depths[n - 1]
    end
  end
end
