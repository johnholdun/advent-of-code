class Response
  def call(input)
    input
      .map do |line|
        items = line.split('')
        left = items[0...items.size / 2]
        right = items[items.size / 2...items.size]
        ord = (left & right).first.ord
        ord - ((ord < 97) ? (64 - 26) : 96)
      end
      .sum
  end
end
