class Response
  def call(lines)
    seeds = []
    maps = []

    lines.each do |line|
      next if line == ''

      if line =~ /^seeds: (.+)/
        seeds = Regexp.last_match[1].split(' ').map(&:to_i)
        next
      end

      if line =~ /^(.+)-to-(.+) map:/
        _, from_map, to_map = Regexp.last_match.to_a
        maps.push(from: from_map, to: to_map, links: [])
        next
      end

      maps.last[:links].push(line.split(' ').map(&:to_i))
    end

    categories = maps.map { |m| m[:to] }

    seeds
      .map do |seed|
        categories.reduce(seed) do |number, category|
          next number if category == 'seed'
          link =
            maps
              .find { |m| m[:to] == category }[:links]
              .find do |dest, source, length|
                source <= number && source + length > number
              end

          next number unless link
          number + link[0] - link[1]
        end
      end
      .min
  end
end
