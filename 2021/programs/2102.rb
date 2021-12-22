class Response
  SPLITS =
    %w(111 112 113 121 122 123 131 132 133 211 212 213 221 222 223 231 232 233 311 312 313 321 322 323 331 332 333)
      .map { |c| c.split('').map(&:to_i) }
  FREQUENCIES =
    SPLITS
      .map { |s| s.inject(:+) }
      .group_by(&:itself)
      .map { |s, cs| [s, cs.size] }
      .to_h

  def call(input)
    positions = input.map { |l| l.split(' ').last.to_i }
    win_frequencies = positions.map { |p| winning_rolls(p) }
    wins = [0, 0]
    every_possible_turn_count = win_frequencies.flat_map(&:keys).uniq.sort
    wins_by_turn_count = every_possible_turn_count.map { |l| [l, win_frequencies.map { |h| h[l].to_i }] }.to_h

    wins_by_turn_count.each do |turn_count, win_frequencies|
      wins_at_this_length = win_frequencies.sum
      plays_at_this_length = 27 ** turn_count
      games_at_this_length = wins_at_this_length * (plays_at_this_length - wins_at_this_length)
      wins[0] += games_at_this_length * 0.5
      wins[1] += games_at_this_length * 0.5
      # win_frequencies.each_with_index do |frequency, index|
      #   other_index = index.zero? ? 1 : 0
      #   max_possible_losing_plays = 27 ** turn_count
      #   winning_plays =
      #     wins_by_turn_count.keys.select do |key|
      #       (index.zero? ? key < turn_count : key <= turn_count)
      #     end.map { |k| wins_by_turn_count[k][other_index] }.sum
      #   losing_plays = max_possible_losing_plays - wins[other_index]
      #   wins[index] += frequency * losing_plays
      # end
    end

    return wins.sum + 0

    positions.each_with_index.map do |position, index|
      other_position = positions[index.zero? ? 1 : 0]
      winning_rolls(position).each do |turn_count, frequency|
        # if the other player would win in fewer turns, this game would never
        # actually get to this turn count, so we disregard it. in a tie, this is
        # a victory for player 1 (index 0).
        defeating_frequency =
          winning_rolls(other_position)
            .keys
            .select { |c| index.zero? ? c <= turn_count : c <= turn_count }
            .map { |k| winning_rolls(other_position)[k] }
            .inject(:+)
            .to_i

        # any other plays by the opponent will lose
        games_at_least_this_long = 27 ** turn_count
        player_turns_that_end_here = frequency
        possible_moves_by_other_player = games_at_least_this_long
        games_that_end_before_here
        wins[index] += frequency * (27 ** turn_count - defeating_frequency)
      end
    end

    wins.inspect

    # every player is gauranteed to hit 21 after no more than 21 turns, because
    # they get at least 1 point per turn
    # each player's game is independent of the other, so we're just figuring out how long it takes each player to win, and how many of the other player's games last longer than that
    # take all winning rolls for each player's starting position and
    # expand them based on the frequencies of each total roll (i.e. 1/27
    # universes has a roll on a turn of 1+1+1)
    # then somehow figure out when those
  end

  private

  def winning_paths
    return @winning_paths if defined?(@winning_paths)
    @winning_paths = []
    paths = (1..10).map { |n| [[0, n]] }
    new_paths = []
    loop do
      paths.each do |path|
        if path.map(&:last).inject(:+) - path.first.last >= 21
          @winning_paths.push(path)
        else
          (3..9).each do |move|
            new_paths.push(path + [[move, (path.last.last - 1 + move) % 10 + 1]])
          end
        end
      end
      break if new_paths.size.zero?
      paths = new_paths
      new_paths = []
    end
    @winning_paths
  end

  def winning_rolls(starting_position)
    @winning_rolls ||= {}
    @winning_rolls[starting_position] ||=
      winning_paths
        .select { |path| path.first.last == starting_position }
        .map { |path| path.map(&:first)[1..-1] }
        .group_by(&:size)
        .map do |turn_count, all_moves|
          [turn_count, all_moves.map { |moves| moves.map { |m| FREQUENCIES[m] }.inject(:*) }.inject(:+)]
        end
        .to_h
  end
end
