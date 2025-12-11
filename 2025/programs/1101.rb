class Response
  def call(input)
    outputs =
      input
        .map do |line|
          name, outs = line.split(': ')
          [name, outs.split(' ')]
        end.to_h

    paths = [['you']]
    count = 0

    loop do
      new_paths = []

      paths.each do |path|
        outputs[path.last].each do |next_device|
          if next_device == 'out'
            count += 1
          else
            new_paths.push(path + [next_device])
          end
        end
      end

      break if paths == new_paths
      paths = new_paths
    end

    count
  end
end
