class Response
  def call(input)
    beams = input.first.size.times.map { 0 }

    input.each do |line|
      line.split('').each_with_index do |char, x|
        case char
        when 'S'
          beams[x] = 1
        when '^'
          if beams[x] > 0
            beams[x - 1] += beams[x]
            beams[x + 1] += beams[x]
            beams[x] = 0
          end
        end
      end
    end

    beams.sum
  end
end
