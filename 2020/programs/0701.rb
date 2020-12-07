require 'set'

class Response
  TARGET = 'shiny gold'.freeze

  def call(input)
    rules =
      input.map do |line|
        color, raw_contents = line.scan(/^(.+) bags contain (.+)\.$/).flatten
        contents =
          raw_contents.split(', ').map do |content|
            quantity, content_color = content.scan(/^(\d+) (.+) bags?$/).flatten
            { quantity: quantity.to_i, color: content_color }
          end

        { original: line, color: color, contents: contents }
      end

    matches = Set.new

    loop do
      starting_count = matches.size
      targets = [TARGET] + matches.to_a

      rules.each do |rule|
        if (targets & rule[:contents].map { |c| c[:color] }).size > 0
          matches.add(rule[:color])
        end
      end

      break if matches.size == starting_count
    end

    matches.size
  end
end
