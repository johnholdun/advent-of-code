class Response
  def call(input)
    instructions =
      input.map do |line|
        if line =~ /mask = (.+)/
          mask =
            Regexp
              .last_match[1]
              .split('')
              .map { |c| c.to_i unless c == 'X' }

          { op: :mask, mask: mask }
        elsif line =~ /mem\[(\d+)\] = (\d+)/
          {
            op: :value,
            position: Regexp.last_match[1].to_i,
            value: Regexp.last_match[2].to_i
          }
        end
      end

    values = Hash.new { |h, k| h[k] = 0 }
    mask = nil

    instructions.each do |instruction|
      case instruction[:op]
      when :mask
        mask = instruction[:mask]
      else
        values[instruction[:position]] =
          sprintf(
            '%036d',
            instruction[:value].to_s(2).to_i
          )
            .to_s
            .split('')
            .each_with_index
            .map { |v, i| mask[i] || v }
            .join('')
            .to_i(2)
      end
    end

    values.values.sum
  end
end
