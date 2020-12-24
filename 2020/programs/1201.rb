class Response
  ROTATION = %i(N E S W)
  VECTORS =
    {
      N: [0, -1],
      E: [1, 0],
      S: [0, 1],
      W: [-1, 0]
    }

  def call(input)
    instructions = input.map do |line|
      command, value = line.scan(/^([A-Z])(\d+)/).flatten
      [command.to_sym, value.to_i]
    end

    x = 0
    y = 0
    dir = :E

    instructions.each do |command, value|
      if %i(L R).include?(command)
        mult = command == :L ? -1 : 1
        old_dir = dir
        dir = ROTATION[(ROTATION.index(dir) + mult * value / 90) % ROTATION.size]
      else
        vector = command == :F ? dir : command
        x += value * VECTORS[vector][0]
        y += value * VECTORS[vector][1]
      end
    end

    x.abs + y.abs
  end
end
