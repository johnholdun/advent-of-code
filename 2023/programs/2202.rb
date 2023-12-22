require 'set'

class Response
  def call(input)
    @above = {}
    @below = {}
    @dependencies = {}
    @bricks =
      input.map  { |l| l.split('~').map { |l| l.split(',').map(&:to_i) } }

    save_cells!
    collapse!

    @above = {}
    @below = {}
    @dependencies = {}


    bricks
      .each_with_index
      .map do |_brick, index|
        dependencies(index).size
      end
      .sum
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
    return @above[brick_index] if @above.key?(brick_index)

    x1, y1, z1, x2, y2, z2 = bricks[brick_index].flatten

    z = [z1, z2].max + 1

    result = Set.new

    (x1..x2).each do |x|
      (y1..y2).each do |y|
        above_index = cells[[x, y, z]]
        result.add(above_index) unless above_index.nil?
      end
    end

    @above[brick_index] = result.to_a
  end

  def below(brick_index)
    return @below[brick_index] if @below.key?(brick_index)

    x1, y1, z1, x2, y2, z2 = bricks[brick_index].flatten

    z = [z1, z2].min - 1

    result = Set.new

    (x1..x2).each do |x|
      (y1..y2).each do |y|
        below_index = cells[[x, y, z]]
        result.add(below_index) unless below_index.nil?
      end
    end

    @below[brick_index] = result.to_a
  end

  def dependencies(index)
    deleted = [index]

    loop do
      new_deletions = []
      deleted.each do |deleted_index|
        above(deleted_index).each do |above_index|
          next if deleted.include?(above_index)
          next if new_deletions.include?(above_index)
          next unless below(above_index).all? { |abi| deleted.include?(abi) }
          new_deletions.push(above_index)
        end
      end

      return deleted - [index] if new_deletions.empty?
      deleted += new_deletions
      new_deletions = []
    end
  end

  # def dependencies(index, deleted = [])
  #   @dependencies[[index, deleted]] ||=
  #     begin
  #       deletions = [index] + deleted
  #       indices = above(index).select { |i2| (below(i2) - deletions).empty? }
  #       deletions += indices
  #       result = indices + indices.flat_map { |i2| dependencies(i2, deletions) }
  #       # puts "(#{index},#{deleted}): #{result} (#{above(index).map { |i2| [i2, below(i2)] }.to_h})"
  #       result.uniq - [index]
  #     end
  # end
end
