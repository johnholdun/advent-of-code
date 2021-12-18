class Number
  attr_accessor :value, :depth

  def initialize(value, depth)
    @value = value
    @depth = depth
  end

  def to_s
    "#{value}/#{depth}"
  end

  def inspect
    to_s
  end
end

class Response
  def call(input)
    nums = input.map { |l| translate(l) }
    nums.flat_map do |left|
      nums.map do |right|
        next 0 if left == right
        magnitude(reduce(add(left.map(&:dup), right.map(&:dup))))
      end
    end.max
  end
  # 13204 too high

  private

  def add(left, right)
    (left + right).map { |n| n.tap { n.depth += 1 } }
  end

  def translate(line)
    depth = -1
    result = []
    line.split('').each do |char|
      case char
      when '['
        depth += 1
      when ']'
        depth -= 1
      when ','
      else
        result.push(Number.new(char.to_i, depth))
      end
    end
    result
  end

  def reduce(num)
    return nil if num.nil?
    reduce(explode(num)) || reduce(split(num)) || num
  end

  def magnitude(num)
    loop do
      max_depth = num.map(&:depth).max
      max_index = num.index { |n| n.depth == max_depth }
      left = num[max_index]
      right = num[max_index + 1]
      puts num.join(' ') if right.nil?
      num[max_index] = Number.new(left.value * 3 + right.value * 2, max_depth - 1)
      num.delete_at(max_index + 1)
      break if num.size == 1
    end

    num[0].value
  end

  def explode(num)
    fourth_index = num.index { |n| n.depth == 4 }
    return unless fourth_index
    fourth_left = num[fourth_index]
    fourth_right = num[fourth_index + 1]
    num[fourth_index - 1].value += fourth_left.value if fourth_index > 0
    num[fourth_index + 2].value += fourth_right.value if num[fourth_index + 2]
    num[fourth_index] = Number.new(0, fourth_left.depth - 1)
    num.delete_at(fourth_index + 1)
    num
  end

  def split(num)
    ten_index = num.index { |n| n.value >= 10 }
    return unless ten_index
    ten = num[ten_index]
    left = (ten.value / 2.0).floor.to_i
    right = (ten.value / 2.0).ceil.to_i
    depth = ten.depth + 1
    num[ten_index] = Number.new(left, depth)
    num.insert(ten_index + 1, Number.new(right, depth))
    num
  end
end
