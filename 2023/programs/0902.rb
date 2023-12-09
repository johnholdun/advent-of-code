class Response
  def call(lines)
    lines
      .map { |l| l.split(' ').map(&:to_i) }
      .map do |set|
        values = [set]

        while !values.last.all?(&:zero?)
          values.push(values.last.each_cons(2).map { |a, b| b - a })
        end

        starts = values.map(&:first)
        difference = starts.pop

        while starts.size > 0
          difference = starts.pop - difference
        end

        difference
      end
      .sum
  end
end
