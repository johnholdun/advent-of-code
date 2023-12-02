class Response
  def call(raw_games)
    games =
      raw_games.map do |game|
        label, pulls = game.split(': ')
        _, id = label.split(' ')
        counts = { 'red' => [0], 'green' => [0], 'blue' => [0] }
        pulls.split('; ').each do |pull|
          pull.split(', ').each do |pull_parts|
            count, color = pull_parts.split(' ')
            counts[color].push(count.to_i)
          end
        end

        { id: id.to_i, counts: counts }
      end

    games
      .map { |g| %w(red green blue).map { |c| g[:counts][c].max }.reduce(:*) }
      .sum
  end
end
