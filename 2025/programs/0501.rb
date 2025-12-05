class Response
  def call(input)
    ranges = []
    ingredients = []
    in_ranges = true

    input.each do |line|
      if line == ''
        in_ranges = false
        next
      end

      if in_ranges
        ranges.push(line.split('-').map(&:to_i))
      else
        ingredients.push(line.to_i)
      end
    end

    ingredients.count do |i|
      ranges.any? do |min, max|
        i >= min && i <= max
      end
    end
  end
end
