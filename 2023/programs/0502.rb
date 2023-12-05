class Response
  def call(lines)
    seeds = []
    maps = []

    lines.each do |line|
      next if line == ''

      if line =~ /^seeds: (.+)/
        seed_ranges = Regexp.last_match[1].split(' ').map(&:to_i)
        seeds = (seed_ranges.size / 2).times.map do |i|
          start, length = seed_ranges[i * 2, 2]
          (start...start + length)
        end

        next
      end

      if line =~ /^(.+)-to-(.+) map:/
        maps.push([])
        next
      end

      dest, source, length = line.split(' ').map(&:to_i)
      maps.last.push([dest - source, (source...source + length)])
    end

    ranges = seeds.map { |s| [s.begin, s.end - 1] }

    maps.each do |map_category|
      # ranges (or sections of ranges) in the input that will reäppended
      new_ranges = []
      # ranges in the input that we won't reconsider once they've been affected
      matched_ranges = []

      map_category.each do |change, op_range|
        # o for "operation," i.e. add a value to numbers within the given range
        ofirst = op_range.first
        olast = op_range.last(1)[0]

        ranges.each_with_index do |range, index|
          next if matched_ranges.include?(index)
          first, last = range

          if ofirst > last || first > olast
            # no intersection
            next
          end

          # we will not use this range again, but we leave it in place because
          # we're iterating
          matched_ranges.push(index)

          # the intersection of the operation range and our given range
          ifirst = [first, ofirst].max
          ilast = [last, olast].min

          # modify the numbers in the intersection and add them to our new list
          new_ranges.push([ifirst + change, ilast + change])

          # if there were any unmodified ranges before or after the
          # intersection, add them back to the end of our list so they may be
          # considered for additional operations

          if ifirst - 1 > first
            ranges.push([first, ifirst - 1])
          end

          if ilast + 1 < last
            ranges.push([ilast + 1, last])
          end
        end
      end

      # clear out any ranges we used and add the new ones to the running list
      matched_ranges.each { |i| ranges[i] = nil }
      ranges = ranges.compact + new_ranges
    end

    ranges.map(&:first).min
  end
end
