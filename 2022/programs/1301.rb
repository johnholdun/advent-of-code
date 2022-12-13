require 'json'

class Response
  def call(input)
    packet_pairs = [[]]

    input.each do |line|
      if line == ''
        packet_pairs.push([])
      else
        packet_pairs.last.push(JSON.parse(line))
      end
    end

    packet_pairs
      .each_with_index
      .select do |(a, b), index|
        correct?(a, b) == 1
      end
      .map { |_, index| index + 1 }
      .sum
  end

  private

  # Returns -1 if the packet is valid, 1 if it's valid, and 0 if validity is
  # undetermined
  def correct?(left, right)
    if left.is_a?(Fixnum) && right.is_a?(Fixnum)
      return 1 if left < right
      return -1 if left > right
      return 0
    end

    if left.is_a?(Array) && right.is_a?(Array)
      left.each_with_index do |l, index|
        r = right[index]
        return -1 if r.nil?
        check = correct?(l, r)
        return check unless check.zero?
      end
      return 1 if right.size > left.size
      return 0
    end

    return correct?([left], right) if left.is_a?(Fixnum)
    return correct?(left, [right])
  end
end
