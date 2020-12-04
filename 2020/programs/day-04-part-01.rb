require './day'

class Day4Part1 < Day
  DAY = 4
  PART = 1

  REQUIRED_FIELDS = %w(byr iyr eyr hgt hcl ecl pid).freeze

  def call
    records =
      input
        .join("\n")
        .split(/\n{2,}/)
        .map { |r| r.split(/\s+/).map { |p| p.split(':') }.to_h }

    records.count { |r| (REQUIRED_FIELDS & r.keys).size == REQUIRED_FIELDS.size }
  end
end
