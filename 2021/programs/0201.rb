class Response
  def call(input)
    x = 0
    y = 0

    input.each do |line|
      direction, unit = line.split(' ')
      unit = unit.to_i
      case direction.to_sym
      when :forward
        x += unit
      when :down
        y += unit
      when :up
        y -= unit
      end
    end

    x * y
  end
end
