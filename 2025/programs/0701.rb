class Response
  def call(input)
    beams = Set.new
    splits = 0

    input.each do |line|
      line.split('').each_with_index do |char, x|
        case char
        when 'S'
          beams.add(x)
        when '^'
          if beams.include?(x)
            splits += 1
            beams.delete(x)
            beams.add(x - 1)
            beams.add(x + 1)
          end
        end
      end
    end

    splits
  end
end
