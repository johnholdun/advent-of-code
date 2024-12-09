class Response
  def call(input)
    files =
      input.first.split('').each_slice(2).each_with_index.map do |(count, after), id|
        { id: id, count: count.to_i, after: after.to_i }
      end

    id = files.last[:id]

    loop do
      file_index = files.find_index { |f| f[:id] == id }
      break unless file_index
      file = files[file_index]

      previous_file_index = files.each_with_index.find_index { |f, i| i < file_index && f[:after] >= file[:count] }

      if previous_file_index
        previous_file = files[previous_file_index]
        files[file_index - 1][:after] += file[:count] + file[:after]
        file[:after] = previous_file[:after] - file[:count]
        previous_file[:after] = 0
        files.delete_at(file_index)
        files.insert(previous_file_index + 1, file)
      end

      id -= 1
    end

    files.map { |f| [f[:id]] * f[:count] + [0] * f[:after] }.flatten.each_with_index.map { |n, i| n * i }.sum
  end
end
