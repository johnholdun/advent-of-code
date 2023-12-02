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

    maxima = { 'red' => 12, 'green' => 13, 'blue' => 14 }

    games
      .select { |g| maxima.all? { |color, count| g[:counts][color].max <= count } }
      .map { |g| g[:id] }
      .sum
  end
end
