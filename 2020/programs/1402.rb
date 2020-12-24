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
            address: Regexp.last_match[1].to_i,
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
        address =
          sprintf(
            '%036d',
            instruction[:address].to_s(2).to_i
          )
            .to_s
            .split('')

        floating_count = mask.count(nil)
        writes_count = 2 ** floating_count

        addresses =
          writes_count.times.map do |n|
            floating_values =
              sprintf(
                "%0#{floating_count}d",
                n.to_s(2).to_i
              )
                .to_s
                .split('')
                .map(&:to_i)

            address
              .each_with_index
              .map do |v, i|
                case mask[i]
                when 0 then v
                when 1 then 1
                else
                  floating_values.shift
                end
              end
              .join('')
              .to_i(2)
          end

        addresses.each do |address|
          values[address] = instruction[:value]
        end
      end
    end

    values.values.flatten.sum
  end
end
