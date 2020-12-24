class Response
  VECTORS =
    {
      N: [0, 1],
      E: [1, 0],
      S: [0, -1],
      W: [-1, 0]
    }

  def call(input)
    instructions = input.map do |line|
      command, value = line.scan(/^([A-Z])(\d+)/).flatten
      [command.to_sym, value.to_i]
    end

    x = 0
    y = 0
    wx = 10
    wy = 1

    instructions.each do |command, value|
      case command
      when :L, :R
        quadrant =
          case [wx >= 0, wy >= 0]
          when [true, true] then 0
          when [true, false] then 1
          when [false, false] then 2
          when [false, true] then 3
          end

        direction = command == :L ? -1 : 1

        (value / 90).abs.times do
          quadrant = (quadrant + direction) % 4

          wx, wy =
            case quadrant
            when 0 then [wy.abs, wx.abs]
            when 1 then [wy.abs, wx.abs * -1]
            when 2 then [wy.abs * -1, wx.abs * -1]
            when 3 then [wy.abs * -1, wx.abs]
            end
        end
      when :F
        value.times do
          x += wx
          y += wy
        end
      else
        wx += value * VECTORS[command][0]
        wy += value * VECTORS[command][1]
      end
    end

    x.abs + y.abs
  end
end
