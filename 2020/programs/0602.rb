class Response
  def call(input)
    input.join("\n").split(/\n{2,}/).map do |answers|
      responses = answers.lines.map { |a| a.scan(/[a-z]/) }
      responses.flatten.uniq.count do |answer|
        responses.all? { |r| r.include?(answer) }
      end
    end.sum
  end
end
