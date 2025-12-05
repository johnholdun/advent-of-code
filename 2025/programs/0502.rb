class Response
  def call(input)
    ranges = []

    input.each do |line|
      break if line == ''
      ranges.push(line.split('-').map(&:to_i))
    end

    loop do
      next_ranges = []

      ranges.each do |min, max|
        found = false
        next_ranges.each_with_index do |(min2, max2), index|
          if min <= max2 + 1 && max >= min2 - 1
            found = true
            next_ranges[index] = [[min, min2].min, [max, max2].max]
            break
          end
        end

        next_ranges.push([min, max]) unless found
      end

      break if next_ranges.size == ranges.size
      ranges = next_ranges
    end

    # 342723286604312 too high
    ranges.map { |min, max| max - min + 1 }.sum
  end
end
