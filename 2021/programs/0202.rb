class Response
  def call(input)
    aim = 0
    x = 0
    y = 0

    input.each do |line|
      direction, unit = line.split(' ')
      unit = unit.to_i
      case direction.to_sym
      when :forward
        x += unit
        y += aim * unit
      when :down
        aim += unit
      when :up
        aim -= unit
      end
    end

    x * y
  end
end
