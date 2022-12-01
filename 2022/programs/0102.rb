class Response
  def call(input)
    elves =
      input.each_with_object([[]]) do |line, collection|
        if line == ''
          collection.push([])
        else
          collection.last.push(line.to_i)
        end
      end

    elves.map(&:sum).sort.last(3).sum
  end
end
