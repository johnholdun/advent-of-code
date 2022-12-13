require 'json'

class Response
  def call(input)
    extras = [[[2]], [[6]]]
    packets =
      input
        .reject(&:empty?)
        .map { |l| JSON.parse(l) }
    packets += extras
    packets.sort! { |a, b| correct?(a, b) }

    extras.map { |p| packets.index(p) + 1 }.reduce(:*)
  end

  private

  # Returns 1 if the packet is valid, -1 if it's valid, and 0 if validity is
  # undetermined (this is the reverse of 1301)
  def correct?(left, right)
    if left.is_a?(Fixnum) && right.is_a?(Fixnum)
      return -1 if left < right
      return 1 if left > right
      return 0
    end

    if left.is_a?(Array) && right.is_a?(Array)
      left.each_with_index do |l, index|
        r = right[index]
        return 1 if r.nil?
        check = correct?(l, r)
        return check unless check.zero?
      end
      return -1 if right.size > left.size
      return 0
    end

    return correct?([left], right) if left.is_a?(Fixnum)
    return correct?(left, [right])
  end
end
