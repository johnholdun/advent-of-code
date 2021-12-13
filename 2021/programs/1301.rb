require 'set'

class Response
  def call(input)
    @page = Set.new
    @folds = []
    input.each do |line|
      if line =~ /^\d+,\d+$/
        page.add(line.split(',').map(&:to_i))
      elsif line =~ /^fold along ([xy])=(\d+)$/
        folds.push([$1, $2.to_i])
      end
    end

    fold!
    page.size
  end

  private

  attr_reader :page, :folds

  def fold!
    axis, line = folds.shift
    before, after = page.to_a.partition { |x, y| (axis == 'x' ? x : y) < line }
    @page = Set.new(before)
    after.each do |x, y|
      x2 = axis == 'y' ? x : line - (x - line)
      y2 = axis == 'x' ? y : line - (y - line)
      page.add([x2, y2])
    end
  end
end
