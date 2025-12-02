class Response
  def call(input)
    input
      .first
      .split(',')
      .flat_map do |range|
        first, last = range.split('-')
        (first.to_i..last.to_i).map do |i|
          yeah?(i) ? i : 0
        end
      end
      .sum
  end

  private

  def yeah?(i)
    s = i.to_s

    (1..(s.size / 2.0).floor).each do |length|
      next if s.size % length != 0
      return true if s == s[0, length] * (s.size / length)
    end

    false
  end
end
