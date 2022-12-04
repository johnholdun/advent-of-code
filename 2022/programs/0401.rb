class Response
  def call(input)
    input.count do |pair|
      ranges = pair.split(',').map { |s| s.split('-').map(&:to_i) }
      [[0, 1], [1, 0]].any? do |a, b|
        ranges[a][0] <= ranges[b][1] && ranges[a][1] >= ranges[b][1]
      end
    end
  end
end
