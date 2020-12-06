class Response
  def call(input)
    input.join("\n").split(/\n{2,}/).map { |as| as.scan(/[a-z]/).uniq.size }.sum
  end
end
