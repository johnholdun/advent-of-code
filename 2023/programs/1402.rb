class Response
  def call(input)
    @rows = input.size
    @cols = input.first.size
    @squares = @rows.times.map { @cols.times.map { false } }
    @rounds = []
    @new_rounds = {}
    @cycles_cache = {}

    input.each_with_index do |line, row|
      line.split('').each_with_index do |char, col|
        if char == '#'
          @squares[row][col] = true
        elsif char == 'O'
          @rounds.push([col, row])
        end
      end
    end

    @squares_by_rotation = [@squares]

    3.times do
      @squares_by_rotation.push(@squares_by_rotation.last.transpose.map(&:reverse))
    end

    # now turn arrays of true/false into indices
    @squares_by_rotation.map! do |squares|
      squares.map! do |line|
        line.each_with_index.select(&:first).map(&:last)
      end
    end

    # rotations of 0-3 push west, south, east, and north, in that order
    @rotation = 3
    @cycles = 0
    @target = 1000000000
    @updated_target = false
    previous_cycle_keys = []

    loop do
      key = @rounds.sort_by(&:itself).to_s

      if @cycles_cache[key]
        unless @updated_target
          @updated_target = true

          cycle_offset = previous_cycle_keys.index(key)
          cycle_length = @cycles - cycle_offset
          last_cycle_position = (@target - cycle_offset) % cycle_length
          @target = @cycles + last_cycle_position - 1
        end

        @rounds = @cycles_cache[key]
      else
        4.times do
          shift
          @rotation = (@rotation + 1) % 4
        end

        @cycles_cache[key] = @rounds.map(&:dup)
      end

      previous_cycle_keys.push(key)

      break if @cycles == @target
      @cycles += 1
    end

    total_load
  end

  private

  def print_field
    @rows.times do |row|
      @cols.times do |col|
        if @squares[row].include?(col)
          print '#'
        elsif @rounds.include?([col, row])
          print 'O'
        else
          print '.'
        end
      end
      puts
    end
  end

  def shift
    dimension_index = @rotation % 2 == 0 ? 0 : 1
    off_index = dimension_index == 0 ? 1 : 0

    dimension = [@cols, @rows][dimension_index]
    dimension.times do |dim|
      squares = @squares_by_rotation[@rotation][dim]

      check_dim = dim
      check_dim = dimension - dim - 1 if [2, 3].include?(@rotation)

      rounds =
        @rounds.each_with_index.select do |c, i|
          c[off_index] == check_dim
        end

      indices = rounds.map(&:last)
      positions = rounds.map { |r| r.first[dimension_index] }.sort
      positions = positions.map { |p| dimension - p - 1 }.reverse if [1, 2].include?(@rotation)
      new_positions = new_rounds(positions, squares)

      new_positions = new_positions.map { |p| dimension - p - 1 } if [1, 2].include?(@rotation)

      new_positions.each do |position|
        c = []
        c[off_index] = check_dim
        c[dimension_index] = position
        @rounds[indices.pop] = c
      end
    end
  end

  # given a 1-dimensional set of positions for rounds and squares, shift all the
  # rounds to the left and return the new round positions
  def new_rounds(rounds, squares)
    return @new_rounds[[rounds, squares]] if @new_rounds[[rounds, squares]]

    result = []
    i = 0
    rounds.each do |round|
      boundary = 0

      squares.each do |square|
        if square < round
          boundary = square + 1
        else
          break
        end
      end

      buffer = 0

      rounds.each do |round2|
        next if round2 < boundary
        break if round2 >= round
        buffer += 1
      end

      result.push(boundary + buffer)
    end

    @new_rounds[[rounds, squares]] = result
  end

  def total_load
    @rounds
      .map do |_x, y|
        @cols - y
      end
      .sum
  end
end
