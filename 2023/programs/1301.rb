class Response
  def call(input)
    images = [[]]
    input.each do |line|
      if line == ''
        images.push([])
      else
        images.last.push(line)
      end
    end

    images.map do |image|
      reflection = find_reflection(image)

      next reflection * 100 if reflection

      image2 = image.first.size.times.map { '' }

      image.each do |line|
        line.split('').each_with_index do |char, x|
          image2[x] += char
        end
      end

      find_reflection(image2)
    end
    .sum
  end

  private

  def find_reflection(image)
    (0...(image.size - 1)).each do |reflection|
      if (0..reflection).all? { |dr| reflection + dr + 1 >= image.size || image[reflection - dr] == image[reflection + dr + 1] }
        return reflection + 1
      end
    end

    nil
  end
end
