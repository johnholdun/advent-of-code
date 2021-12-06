class Response
  TARGET = 256
  SPAWNS = ([9] + [7] * ((TARGET - 9) / 6.0).ceil).freeze

  def call(input)
    birthdates =
      input.first.split(',').map(&:to_i).each_with_object(Hash.new(0)) do |age, hash|
        hash[age - 8] += 1
      end

    (birthdates.keys.min..TARGET).each do |date|
      n = date
      SPAWNS.each do |day|
        n += day
        birthdates[n] += birthdates[date]
      end
    end

    birthdates.keys.select { |d| d <= TARGET }.map { |k| birthdates[k] }.inject(:+)
  end
end
