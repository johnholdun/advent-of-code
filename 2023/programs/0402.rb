class Response
  def call(cards)
    matches =
      cards
        .map do |card|
          winning_string, had_string =
            card.scan(/^Card +\d+: (.+) \| (.+)$/).flatten
          winning = winning_string.split(/ +/)
          had_string.split(/ +/).count { |num| winning.include?(num) }
        end

    counts = matches.map { 1 }

    counts.each_with_index do |count, index|
      card_matches = matches[index]

      card_matches.times do |delta|
        new_index = index + delta + 1
        break unless counts[new_index]
        counts[new_index] += count
      end
    end

    counts.sum
  end
end
