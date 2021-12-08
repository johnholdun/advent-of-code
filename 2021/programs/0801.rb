class Response
  def call(input)
    entries =
      input.map do |line|
        line.split(' | ').map do |part|
          part.split(' ').map do |pattern|
            pattern.split('')
          end
        end
      end

    entries.flat_map(&:last).count do |pattern|
      [2, 3, 4, 7].include?(pattern.size)
    end
  end
end
