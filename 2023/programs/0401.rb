class Response
  def call(cards)
    cards
      .map do |card|
        winning_string, had_string = card.scan(/^Card +\d+: (.+) \| (.+)$/).flatten
        winning = winning_string.split(/ +/)
        count = had_string.split(/ +/).count { |num| winning.include?(num) }
        count.zero? ? 0 : 2 ** (count - 1)
      end
      .sum
  end
end
