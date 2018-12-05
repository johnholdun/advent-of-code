require './day'

class Day2Part2 < Day
  DAY = 2
  PART = 2

  def call
    ids = input.sort.map { |i| i.split('') }
    ids.each do |id1|
      ids.each do |id2|
        next unless difference(id1, id2) == 1
        return id1.each_with_index.select { |i, index| id2[index] == i }.map(&:first).join('')
      end
    end

    nil
  end

  private

  def difference(id1, id2)
    id1.each_with_index.reject { |i, index| i == id2[index] }.size
  end
end
