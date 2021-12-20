require 'set'

class Response
  def call(input)
    @scanners = []
    input.map do |line|
      if line =~ /^--- scanner \d+ ---$/
        scanners.push([])
      elsif line != ''
        scanners.last.push(line.split(',').map(&:to_i))
      end
    end

    maps = Hash.new { |h, k| h[k] = {} }

    scanners.size.times do |scanner_index_left|
      scanners.size.times do |scanner_index_right|
        map = distance_overlaps(scanner_index_left, scanner_index_right)
        # 10 is arbitary, i just know it works well for my input data
        next unless map.size >= 10
        maps[scanner_index_left][scanner_index_right] = map
        maps[scanner_index_right][scanner_index_left] = map.map(&:reverse)
      end
    end

    @transforms = {}

    maps.each do |scanner_index_left, hash|
      hash.each do |scanner_index_right, beacon_indices|
        offset = []
        beacon_index_left1, beacon_index_right1 = beacon_indices[0]
        beacon_index_left2, beacon_index_right2 = beacon_indices[1]
        beacon_left1 = scanners[scanner_index_left][beacon_index_left1]
        beacon_right1 = scanners[scanner_index_right][beacon_index_right1]
        beacon_left2 = scanners[scanner_index_left][beacon_index_left2]
        beacon_right2 = scanners[scanner_index_right][beacon_index_right2]
        distance_left = []
        distance_right = []
        [0, 1, 2].each do |index|
          distance_left[index] = beacon_left1[index] - beacon_left2[index]
          distance_right[index] = beacon_right1[index] - beacon_right2[index]
        end
        rotation = (0...24).find { |i| rotate(distance_right, i) == distance_left }
        reverse_rotation = (0...24).find { |i| rotate(distance_left, i) == distance_right }
        offset = rotate(beacon_right1, rotation).each_with_index.map { |v, i| v - beacon_left1[i] }
        reverse_offset = rotate(beacon_left1, reverse_rotation).each_with_index.map { |v, i| v - beacon_right1[i] }
        @transforms[[scanner_index_left, scanner_index_right]] = {
          rotation: rotation,
          offset: offset
        }

        @transforms[[scanner_index_right, scanner_index_left]] = {
          rotation: reverse_rotation,
          offset: reverse_offset
        }
      end
    end

    last_size = scanners.map(&:size).inject(:+)

    loop do
      scanners.size.times do |left_index|
        scanners.size.times do |right_index|
          next if left_index == right_index
          collected_left = collect_beacons(left_index, right_index)
          scanners[left_index] += collected_left
        end
      end

      new_size = scanners.map(&:size).inject(:+)
      break if new_size == last_size
      last_size = new_size
    end

    scanners[0].size
  end

  private

  attr_reader :scanners, :transforms

  def beacon_distances
    @beacon_distances ||=
      scanners.map do |beacons|
        beacons.each_with_index.map do |_, i|
          distances(beacons, i)
        end
      end
  end

  def distances(beacons, index)
    beacon = beacons[index]
    beacons
      .select { |b| b != beacon }
      .map { |b| distance(b, beacon) }
  end

  def distance(p1, p2)
    (p1[0] - p2[0]).abs + (p1[1] - p2[1]).abs + (p1[2] - p2[2]).abs
  end

  def distance_overlaps(left_index, right_index)
    return [] if left_index >= right_index
    results = []
    beacon_distances[left_index].each_with_index do |distances_left, beacon_index_left|
      beacon_distances[right_index].each_with_index do |distances_right, beacon_index_right|
        # 0.4 is arbitary, i just know it works well for my input data
        if (distances_left & distances_right).size / distances_left.size.to_f >= 0.4
          results.push([beacon_index_left, beacon_index_right])
        end
      end
    end
    results
  end

  def collect_beacons(source_index, destination_index)
    return [] unless transforms[[source_index, destination_index]]
    scanners[destination_index].each_with_index.map do |pos|
      transform_position(source_index, destination_index, pos)
    end.reject { |p| scanners[source_index].include?(p) }
  end

  def transform_position(source_index, destination_index, point)
    transform = transforms[[source_index, destination_index]]
    rotate(point, transform[:rotation]).each_with_index.map do |value, i|
      value - transform[:offset][i]
    end
  end

  # stole this from here, i'm sorry
  # https://www.reddit.com/r/adventofcode/comments/rjwhdv/2021_day19_i_need_help_understanding_how_to_solve/hp65cya/
  def rotate(point, index)
    x, y, z = point
    case index
    when 0 then [+x, +y, +z]
    when 1 then [+x, -z, +y]
    when 2 then [+x, -y, -z]
    when 3 then [+x, +z, -y]
    when 4 then [-x, -y, +z]
    when 5 then [-x, +z, +y]
    when 6 then [-x, +y, -z]
    when 7 then [-x, -z, -y]
    when 8 then [+y, +z, +x]
    when 9 then [+y, -x, +z]
    when 10 then [+y, -z, -x]
    when 11 then [+y, +x, -z]
    when 12 then [-y, -z, +x]
    when 13 then [-y, +x, +z]
    when 14 then [-y, +z, -x]
    when 15 then [-y, -x, -z]
    when 16 then [+z, +x, +y]
    when 17 then [+z, -y, +x]
    when 18 then [+z, -x, -y]
    when 19 then [+z, +y, -x]
    when 20 then [-z, -x, +y]
    when 21 then [-z, +y, +x]
    when 22 then [-z, +x, -y]
    when 23 then [-z, -y, -x]
    else
      raise "invalid rotation #{index.inspect}"
    end
  end
end
