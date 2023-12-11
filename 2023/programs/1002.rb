require 'set'

class Response
  BOXES = %w(| ┃ - ━ L ┗ J ┛ 7 ┓ F ┏ S *).each_slice(2).to_h
  DIRECTIONS = %i(west east north south).freeze
  OPPOSITES = { north: :south, south: :north, east: :west, west: :east }.freeze
  NEIGHBORS = [[-1, 0], [1, 0], [0, -1], [0, 1]].freeze
  TURNS = {
    left: { north: :west, west: :south, south: :east, east: :north },
    right: { north: :east, east: :south, south: :west, west: :north }
  }.freeze

  def call(lines)
    @lines =
      [
        ' ' * (lines.first.size * 2  + 1),
        lines.map do |line|
          [
            ' ' + line.split('').join('?') + ' ',
            ' ' + line.size.times.map { '?' }.join(' ') + ' '
          ]
        end,
        ' ' * (lines.first.size * 2  + 1)
      ]
      .flatten

    @lines.each_with_index do |line, y|
      line.split('').each_with_index do |tile, x|
        next unless tile == '?'

        if '|7F'.include?(@lines[y - 1][x])
          char = '|'
        elsif '|JL'.include?(@lines[y + 1][x])
          char = '|'
        elsif '-LF'.include?(@lines[y][x - 1])
          char = '-'
        elsif '-7J'.include?(@lines[y][x + 1])
          char = '-'
        else
          char = ' '
        end

        @lines[y][x] = char
      end
    end

    map = {}
    start = nil
    the_loop = {}

    @lines.each_with_index do |line, y|
      line.split('').each_with_index do |tile, x|
        next if '. '.include?(tile)
        key = [x, y]
        start = key if tile == 'S'

        map[key] =
          case tile
          when '|' then %i(north south)
          when '-' then %i(east west)
          when 'L' then %i(east north)
          when 'J' then %i(north west)
          when '7' then %i(south west)
          when 'F' then %i(east south)
          when 'S' then []
          end
      end
    end

    DIRECTIONS.each do |direction|
      if map[look(start, direction)] && map[look(start, direction)].include?(OPPOSITES[direction])
        map[start].push(direction)
      end
    end

    @lines[start[1]][start[0]] =
      case map[start].sort
      when %i(north south) then '|'
      when %i(east west) then '-'
      when %i(east north) then 'L'
      when %i(north west) then 'J'
      when %i(south west) then '7'
      when %i(east south) then 'F'
      end

    the_loop = { start => true }
    last_key = start

    loop do
      n1, n2 = map[last_key].map { |d| look(last_key, d) }
      last_key = nil

      if the_loop.include?(n1)
        unless the_loop.include?(n2)
          last_key = n2
        end
      else
        last_key = n1
      end

      break unless last_key
      the_loop[last_key] = true
    end

    # @lines.each_with_index do |line, y|
    #   line.split('').each_with_index do |tile, x|
    #     print the_loop[[x, y]] ? BOXES[tile] : '.'
    #   end
    #   puts
    # end

    # Find a point that is definitely on the outside and adjacent to the loop by
    # starting at 0,0 and walking around
    raise "uhh" if the_loop[[0, 0]]

    turtle = []

    catch(:got_a_turtle_going_here_yall) do
      adjacent_point = [0, 0]
      i = -1
      route = [:east, :south]

      loop do
        DIRECTIONS.each do |direction|
          point = look(adjacent_point, direction)
          if the_loop[point]
            # the turtle is standing on a non-loop tile and a section of the
            # loop is adjacent to it in `direction`, so we can start walking
            # from here while keeping our right hand (flipper?) on the loop
            turtle.push([
              adjacent_point,
              TURNS[:right][OPPOSITES[direction]]
            ])

            throw :got_a_turtle_going_here_yall
          end
        end

        adjacent_point = look(adjacent_point, route[(i += 1) % route.size])

        raise "uhhhhhhhhhhhhh" if adjacent_point[0] >= @lines.first.size || adjacent_point[1] >= @lines.size
      end
    end

    loop do
      adjacent_point, facing = turtle.last
      turn = check_turn(adjacent_point, facing)
      move = true

      if turn
        direction, side = turn

        if side == :outside
          # for an outside turn, we move an extra space in the current
          # direction before turning the corner
          adjacent_point = look(adjacent_point, facing)
          break if adjacent_point == turtle.first.first
          turtle.push([adjacent_point, facing])
          # puts turtle.last.inspect + " (extra for outside)"
        end

        facing = TURNS[direction][facing]
      else
        # check the loop tile for the next turn, and if it's inside, turn but don't step forward
        next_turn = check_turn(look(adjacent_point, facing), facing)
        if next_turn
          next_direction, next_side = next_turn
          if next_side == :inside
            move = false
            facing = TURNS[next_direction][facing]
          end
        end
      end

      if move
        adjacent_point = look(adjacent_point, facing)
      end
      # puts "? #{adjacent_point} #{turtle.first.first}"
      break if adjacent_point == turtle.first.first
      turtle.push([adjacent_point, facing])
      # puts turtle.last.inspect + " - turn: #{turn.inspect}"

      # break if turtle.size > 100
      # break if turtle.size > @lines.first.size * @lines.size
    end

    # return turtle.map(&:inspect)

    outsides = turtle.map { |p, _| [p, true] }.to_h
    new_outsides = outsides.keys
    loop do
      old_outsides = new_outsides
      new_outsides = []
      old_outsides.each do |position|
        DIRECTIONS.each do |direction|
          next_position = look(position, direction)
          x, y = next_position
          next if outsides[next_position]
          next if the_loop[next_position]
          next unless @lines[y] && @lines[y][x]
          # next if @lines[y][x] == ' '
          new_outsides.push(next_position)
          outsides[next_position] = true
        end
      end
      # print '…'
      break if new_outsides.size.zero?
    end
    # puts

    count = 0

    @lines.each_with_index do |line, y|
      line.split('').each_with_index do |tile, x|
        if !the_loop[[x, y]] && !outsides[[x, y]] && tile != ' ' && x % 2 == 1 && y % 2 == 1
          count += 1
        end
      end
    end

    count
  end

  private

  def look(point, direction)
    x, y = point

    case direction
    when :north then [x, y - 1]
    when :south then [x, y + 1]
    when :east then [x + 1, y]
    when :west then [x - 1, y]
    end
  end

  def check_turn(point, facing)
    x, y = look(point, TURNS[:right][facing])

    return unless @lines[y] && @lines[y][x]

    case [@lines[y][x], facing]
    when ['L', :south] then [:left, :inside]
    when ['L', :west] then [:right, :outside]
    when ['J', :south] then [:right, :outside]
    when ['J', :east] then [:left, :inside]
    when ['7', :north] then [:left, :inside]
    when ['7', :east] then [:right, :outside]
    when ['F', :north] then [:right, :outside]
    when ['F', :west] then [:left, :inside]
    end
  end
end
