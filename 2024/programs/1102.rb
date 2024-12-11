class Response
  def call(input)
    counts = input.first.split(' ').map { |s| [s.to_i, 1] }.to_h

    75.times do
      counts.dup.each do |value, count|
        counts[value] -= count
        new_values =
          if value == 0
            [1]
          elsif value.to_s.size.even?
            digits = value.to_s
            [
              digits[0...digits.size / 2].to_i,
              digits[digits.size / 2..].to_i
            ]
          else
            [value * 2024]
          end
        new_values.each do |new_value|
          counts[new_value] ||= 0
          counts[new_value] += count
        end
      end
    end

    counts.values.sum
  end
end
