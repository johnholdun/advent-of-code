class Response
  def call(input)
    input
      .first
      .split(',')
      .flat_map do |range|
        first, last = range.split('-')
        (first.to_i..last.to_i).map do |i|
          i.to_s =~ /^(.+)\1$/ ? i : 0
        end
      end
      .sum
  end
end
