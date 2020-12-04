require './day'

class Day4Part2 < Day
  DAY = 4
  PART = 2

  REQUIRED_FIELDS = %i(byr iyr eyr hgt hcl ecl pid).freeze
  HEIGHT_RANGES = {
    cm: (150..193),
    in: (59..76)
  }
  EYE_COLORS = %w(amb blu brn gry grn hzl oth)

  def call
    records =
      input
        .join("\n")
        .split(/\n{2,}/)
        .map do |record|
          record.split(/\s+/).map do |pair|
            key, value = pair.split(':')
            [key.to_sym, value]
          end.to_h
        end

    records.count do |record|
      next unless (REQUIRED_FIELDS & record.keys).size == REQUIRED_FIELDS.size

      # byr (Birth Year) - four digits; at least 1920 and at most 2002.
      next unless (1920..2002).include?(record[:byr].to_i)

      # iyr (Issue Year) - four digits; at least 2010 and at most 2020.
      next unless (2010..2020).include?(record[:iyr].to_i)

      # eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
      next unless (2020..2030).include?(record[:eyr].to_i)

      # hgt (Height) - a number followed by either cm or in:
      #   If cm, the number must be at least 150 and at most 193.
      #   If in, the number must be at least 59 and at most 76.
      _, height_value, height_unit = record[:hgt].match(/^(\d+)(cm|in)$/).to_a
      next unless height_value && height_unit && HEIGHT_RANGES[height_unit.to_sym].include?(height_value.to_i)

      # hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
      next unless record[:hcl] =~ /^#[0-9a-f]{6}$/

      # ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
      next unless EYE_COLORS.include?(record[:ecl])

      # pid (Passport ID) - a nine-digit number, including leading zeroes.
      next unless record[:pid] =~ /^[0-9]{9}$/

      true
    end
  end
end
