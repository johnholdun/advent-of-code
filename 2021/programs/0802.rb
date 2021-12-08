require 'json'
class Response
  def call(input)
    entries =
      input.map do |line|
        line.split(' | ').map do |part|
          part.split(' ').map do |pattern|
            pattern.split('')
          end
        end
      end

    entries.map { |p, o| parse(p, o) }.inject(:+)
  end

  private

  def parse(pattern, output)
    digits = {
      1 => pattern.find { |p| p.size == 2 },
      7 => pattern.find { |p| p.size == 3 },
      4 => pattern.find { |p| p.size == 4 },
      8 => pattern.find { |p| p.size == 7 },
    }

    digits[3] = pattern.find { |p| p.size == 5 && (p & digits[1]).size == 2 }
    digits[5] = pattern.find { |p| p.size == 5 && p != digits[3] && (p & digits[4]).size == 3 }
    digits[2] = pattern.find { |p| p.size == 5 && p != digits[3] && p != digits[5] }

    digits[9] = pattern.find { |p| p.size == 6 && (p & digits[3]).size == 5 }
    digits[6] = pattern.find { |p| p.size == 6 && p != digits[9] && (p & digits[5]).size == 5 }
    digits[0] = pattern.find { |p| p.size == 6 && p != digits[6] && p != digits[9] }

    digits_by_pattern = digits.map { |k,v | [v.sort.join, k] }.to_h
    output.map { |o| digits_by_pattern[o.sort.join] }.join.to_i
  end
end
