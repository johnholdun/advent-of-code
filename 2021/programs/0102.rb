class Response
  def call(input)
    @depths = input.map(&:to_i)

    (1..(depths.size - 3)).count do |n|
      range(n) > range(n - 1)
    end
  end

  private

  attr_reader :depths

  def range(i)
    depths[i, 3].to_a.inject(:+)
  end
end
