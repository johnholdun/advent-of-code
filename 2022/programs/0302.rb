class Response
  def call(input)
    input
      .each_slice(3)
      .map do |group|
        badge =
          group.first.split('').find do |char|
            [1, 2].all? { |i| group[i].include?(char) }
          end
        ord = badge.ord
        ord - ((ord < 97) ? (64 - 26) : 96)
      end
      .sum
  end
end
