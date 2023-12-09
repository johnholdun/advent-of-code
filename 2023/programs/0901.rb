class Response
  def call(lines)
    lines
      .map { |l| l.split(' ').map(&:to_i) }
      .map do |set|
        values = [set]
        while !values.last.all?(&:zero?)
          values.push(values.last.each_cons(2).map { |a, b| b - a })
        end
        values.map(&:last).sum
      end
      .sum
  end
end
