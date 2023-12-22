require 'set'

class Response
  def call(input)
    @bricks =
      input.map  { |l| l.split('~').map { |l| l.split(',').map(&:to_i) } }

    save_cells!
    collapse!

    bricks.each_with_index.count do |_brick, index|
      bricks_above = above(index)
      bricks_above.empty? || bricks_above.all? { |i2| (below(i2) - [index]).size > 0 }
    end
  end

  private

  attr_reader :bricks, :cells

  def save_cells!
    @cells = {}

    bricks.each_with_index do |((x1, y1, z1), (x2, y2, z2)), index|
      (x1..x2).each do |x|
        (y1..y2).each do |y|
          (z1..z2).each do |z|
            @cells[[x, y, z]] = index
          end
        end
      end
    end
  end

  def collapse!
    loop do
      changes = {}

      bricks.each_with_index do |((x1, y1, z1), (x2, y2, z2)), index|
        dz = 0
        z = [z1, z2].min - 1

        loop do
          break if z.zero?
          vacant = true

          (x1..x2).each do |x|
            break unless vacant
            (y1..y2).each do |y|
              if cells[[x, y, z]]
                vacant = false
                break
              end
            end
          end

          if vacant
            dz -= 1
            z -= 1
          else
            break
          end
        end

        changes[index] = dz unless dz.zero?
      end

      break if changes.empty?
      # tried to do this more efficiently than clobbering @cells every time; didn't work; not sure why
      changes.each do |index, dz|
        # x1, y1, z1, x2, y2, z2 = bricks[index].flatten
        bricks[index][0][2] += dz
        bricks[index][1][2] += dz
        # dz.abs.times do |i|
        #   (x1..x2).each do |x|
        #     (y1..y2).each do |y|
        #       (z1..z2).each do |z|
        #         cells.delete([x, y, z + i]) if cells[[x, y, z + i]] == index
        #         cells[[x, y, z + dz + i]] = index
        #       end
        #     end
        #   end
        # end
      end
      save_cells!
    end
  end

  def above(brick_index)
    x1, y1, z1, x2, y2, z2 = bricks[brick_index].flatten

    z = [z1, z2].max + 1

    result = Set.new

    (x1..x2).each do |x|
      (y1..y2).each do |y|
        above_index = cells[[x, y, z]]
        result.add(above_index) unless above_index.nil?
      end
    end

    result.to_a
  end

  def below(brick_index)
    x1, y1, z1, x2, y2, z2 = bricks[brick_index].flatten

    z = [z1, z2].min - 1

    result = Set.new

    (x1..x2).each do |x|
      (y1..y2).each do |y|
        below_index = cells[[x, y, z]]
        result.add(below_index) unless below_index.nil?
      end
    end

    result.to_a
  end
end
