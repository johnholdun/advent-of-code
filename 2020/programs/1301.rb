class Response
  def call(input)
    departure = input.shift.to_i
    ids = input.shift.split(',').select { |i| i != 'x' }.map(&:to_i).sort

    id, time =
      ids
        .map do |id|
          [id, (departure / id.to_f).ceil * id]
        end
        .sort_by(&:last)
        .first

    id * (time - departure)
  end
end
