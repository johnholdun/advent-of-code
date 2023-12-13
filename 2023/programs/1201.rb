class Response
  def call(lines)
    lines.map do |line|
      icons, broken_counts = line.split(' ')

      broken_counts = broken_counts.split(',').map(&:to_i)

      working_count = icons.size - broken_counts.sum
      spaces_to_fill = broken_counts.size + 1 # spaces between each item as well as before and after

      # it's okay to have zeroes at the start or end, but every gap in between
      # two groups must be non-zero
      addend_groups =
        find_addends(working_count, spaces_to_fill)
          .reject { |as| as[1..-2].any?(&:zero?) }

      addend_groups
        .map do |addends|
          result = ''
          addends.each_with_index do |addend, index|
            result += '.' * addend
            result += '#' * broken_counts[index] if broken_counts[index]
          end
          result
        end
        .count do |string|
          valid?(string, icons)
        end
    end
    .sum
  end

  def find_addends(sum, count)
    if count == 1
      return [[sum]]
    end

    if count == 2
      return (0..sum).map { |n| [n, sum - n] }
    end

    return (0..sum).map do |n|
      previous_addends = find_addends(sum - n, count - 1)
      previous_addends.map { |addends| [n] + addends }
    end.flatten(1)
  end

  def valid?(trial_string, template_string)
    template_string.split('').each_with_index.all? do |c, i|
      c == '?' || c == trial_string[i]
    end
  end
end
