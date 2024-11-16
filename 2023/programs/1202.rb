# thanks to this person for sharing their solution, which helped me understand
# how to approach this:
# https://www.reddit.com/r/adventofcode/comments/18ge41g/comment/kd09kvj/
class Response
  def call(lines)
    lines.map do |line|
      icons, broken_counts = line.split(' ')
      broken_counts = broken_counts.split(',').map(&:to_i)

      icons = ([icons] * 5).join('?')
      broken_counts *= 5

      count(icons, broken_counts)
    end
    .sum
  end

  private

  def count(icons, broken_counts)
    @count ||= {}
    @count[[icons, broken_counts]] ||= unmemoized_counts(icons, broken_counts)
  end

  def unmemoized_counts(icons, broken_counts)
    if icons.nil? || icons.size.zero?
      return broken_counts.sum.zero? ? 1 : 0
    end

    return count(icons[1..], broken_counts) if icons[0] == '.'

    if broken_counts.size.zero?
      return icons.include?('#') ? 0 : 1
    end

    return 0 if icons.size < broken_counts.sum + broken_counts.size - 1

    if icons[0] == '#'
      return 0 if icons[0...broken_counts.first].include?('.')
      return 0 if icons.size >= broken_counts.first && icons[broken_counts.first] == '#'
      return count(icons[(broken_counts.first + 1)..], broken_counts[1..])
    end

    ['#', '.'].map { |i| count("#{i}#{icons[1..]}", broken_counts) }.sum
  end
end
