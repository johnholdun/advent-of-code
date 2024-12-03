class Response
  def call(input)
    ops =
      input
        .join('')
        .scan(/(?:(do)\(\)|(don't)\(\)|(mul)\((\d+),(\d+)\))/)

    sum = 0
    enabled = true

    ops.each do |op|
      op = op.compact

      case op.first
      when 'do'
        enabled = true
      when 'don\'t'
        enabled = false
      when 'mul'
        if enabled
          sum += op[1].to_i * op[2].to_i
        end
      end
    end

    sum
  end
end
