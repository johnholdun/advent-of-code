class Response
  def call(lines)
    lines
      .map { |l| Hand.from_line(l) }
      .sort_by(&:strength)
      .each_with_index
      .map { |h, i| h.bid * (i + 1) }
      .sum
  end

  class Hand
    LABELS = %w(A K Q T 9 8 7 6 5 4 3 2 J).freeze

    attr_reader :cards, :bid

    def initialize(cards, bid)
      @cards = cards
      @bid = bid
    end

    def self.from_line(line)
      cards, bid = line.split(' ')
      cards = cards.split('')
      bid = bid.to_i
      new(cards, bid)
    end

    def type
      @type ||=
        case tally

        # Five of a kind, where all five cards have the same label: AAAAA
        when [5] then 0

        # Four of a kind, where four cards have the same label and one card has
        # a different label: AA8AA
        when [4, 1] then 1

        # Full house, where three cards have the same label, and the remaining
        # two cards share a different label: 23332
        when [3, 2] then 2

        # Three of a kind, where three cards have the same label, and the
        # remaining two cards are each different from any other card in the
        # hand: TTT98
        when [3, 1, 1] then 3

        # Two pair, where two cards share one label, two other cards share a
        # second label, and the remaining card has a third label: 23432
        when [2, 2, 1] then 4

        # One pair, where two cards share one label, and the other three cards
        # have a different label from the pair and each other: A23A4
        when [2, 1, 1, 1] then 5

        # High card, where all cards' labels are distinct: 23456
        else 6
        end
    end

    # strength is in an integer made of the type and the value of each card, in
    # the order they're presented in the hand, but in base 12 so those parts are
    # considered in order when sorting (i.e. a higher type value wins regardless
    # of individual cards' values)
    def strength
      return @strength if defined?(@strength)

      strength_parts =
        [6 - type] +
        cards.map { |c| 1 + LABELS.size - LABELS.index(c) }

      @strength =
        strength_parts
          .reverse
          .each_with_index
          .map { |p, i| p * LABELS.size ** i }
          .sum
    end

    private

    def tally
      return @tally if defined?(@tally)
      non_jokers = cards.reject { |c| c == 'J' }
      return @tally = [5] if non_jokers.size.zero?
      @tally = non_jokers.tally.values.sort.reverse
      @tally[0] += cards.size - non_jokers.size
      @tally
    end
  end
end
