require 'set'

class Response
  TARGET = 'shiny gold'.freeze

  def call(input)
    @input = input
    bag_count(TARGET)
  end

  private

  attr_reader :input

  def rules
    @rules ||=
      input.map do |line|
        color, raw_contents = line.scan(/^(.+) bags contain (.+)\.$/).flatten
        contents =
          if raw_contents == 'no other bags'
            {}
          else
            raw_contents.split(', ').map do |content|
              quantity, content_color = content.scan(/^(\d+) (.+) bags?$/).flatten
              [content_color, quantity.to_i]
            end.to_h
          end

        [color, contents]
      end.to_h
  end

  def bag_count(color)
    rules[color].map { |color, count| count * (1 + bag_count(color)) }.sum
  end
end
