class Response
  USE_BROKEN_IDEA = false

  ROLLS =
    [1, 2, 3]
      .product([1, 2, 3])
      .product([1, 2, 3])
      .map { |r| r.flatten.sum }
      .sort
      .freeze

  def call(input)
    if USE_BROKEN_IDEA
      # The idea here, which doesn't seem to work yet but I don't know why:
      #
      # 1. For each starting position, find all the possible wins by number of
      #    turns. This should (I think?) represent every possible game played by
      #    this player, because even if they other player does nothing, this
      #    player is guaranteed to win by turn 21.
      # 2. Consider that every one of those games is played against one of the
      #    games recorded for the other player. Compare these batches of games
      #    and mark a win based on who took fewer turns.
      # 3. Add up all the wins by player!

      positions = input.map { |i| i.scan(/\d+$/).last.to_i }

      # A weird thing is that `wins_by_turns` seems to return the same result
      # regardless of the input. I'm not smart enough to know if that means
      # there's a bug in my code, or the score outcomes are actually independent
      # of the starting position!
      a, b = positions.map { |p| wins_by_turns(p) }

      a_wins =
        a.map do |turns, wins|
          wins * b.select { |k, v| k >= turns }.values.sum
        end
        .sum

      b_wins =
        b.map do |turns, wins|
          wins * a.select { |k, v| k > turns }.values.sum
        end
        .sum

      [a_wins, b_wins].max
    else
      @states = {}
      position1, position2 = input.map { |i| i.scan(/\d+$/).last.to_i }
      # Shout out to Jonathan Paulson for sharing and explaining his solution:
      # https://github.com/jonathanpaulson/AdventOfCode/blob/master/2021/21.py
      # https://www.youtube.com/watch?v=a6ZdJEntKkk
      #
      # I'm going to re-explain this so I feel good about getting credit for my
      # version of the solution.
      #
      # Even though there are 27 possible outcomes after each player's turn, the
      # board is small and cyclical so there are only so many possible states that
      # any game can be in. The fact that no score will ever exceed 21 (or be
      # slightly over 21) also keeps the number of states low. We can store every
      # possible state as a combination of each player's current position and
      # current score, and therefore save a ton of time on calculation.
      #
      # To be honest this memoization seems to me to not be saving that much
      # computation, but I guess it really adds up! Computers love to look up
      # numbers they've already seen way more than they love adding them together
      # (but let's be clear, they love ALL of it).
      jonathan(position1, position2).max
    end
  end

  def jonathan(position1, position2, score1 = 0, score2 = 0)
    return [1, 0] if score1 >= 21
    return [0, 1] if score2 >= 21

    key = [position1, position2, score1, score2]
    return @states[key] if @states.key?(key)

    wins = [0, 0]

    ROLLS.each do |move|
      new_position1 = (position1 + move - 1) % 10 + 1

      # This is definitely not something I would have picked up without
      # Jonathan's help, but look: we actually flip players 1 and 2 here to
      # calculate the other player's score, because we can memoize them in
      # either order as long as the position and score stay related. It feels
      # like there's a further optimization to be made here because each
      # player's game is actually independent of the other's, and all we need to
      # know is when a given position and a given number of rolls reaches the
      # winning score, then compare the number of turns to the number of turns
      # for the same rolls starting from the other position. But I don't really
      # understand what I'm saying so I'm glad to have had Jonathan's help.
      win_2, win_1 =
        jonathan \
          position2,
          new_position1,
          score2,
          score1 + new_position1

      wins[0] += win_1
      wins[1] += win_2
    end

    @states[key] = wins
  end

  def wins_by_turns(position)
    wins = Hash.new(0)
    games = [[position, 0]]

    # you get at least 1 point per turn so there will never be more than 21
    # turns to get to 21
    (1..21).each do |turns|
      old_games = games
      games = []
      old_games.each do |position, score|
        ROLLS.each do |roll|
          new_position = (position + roll - 1) % 10 + 1
          new_score = score + roll

          if new_score >= 21
            wins[turns] += 1
          else
            games.push([new_position, new_score])
          end
        end
      end
    end

    wins
  end
end
