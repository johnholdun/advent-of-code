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
      smudged_reflection(image)
    end
    .sum
  end

  private

  def smudged_reflection(image)
    old_reflection = find_either_reflection(image)

    image.size.times do |row|
      image.first.size.times do |column|
        new_image = image.map(&:dup)
        old_icon = new_image[row][column]
        new_image[row][column] = old_icon == '.' ? '#' : '.'
        reflection = find_either_reflection(new_image, old_reflection)
        if reflection && reflection != old_reflection
          return reflection
        end
      end
    end

    raise 'whoops'
  end

  def find_either_reflection(image, reflection_to_ignore = nil)
    row_reflection_to_ignore =
      if reflection_to_ignore && reflection_to_ignore >= 100
        reflection_to_ignore / 100
      end

    reflection = find_reflection(image, row_reflection_to_ignore)

    return reflection * 100 if reflection

    column_reflection_to_ignore =
      if reflection_to_ignore && reflection_to_ignore < 100
        reflection_to_ignore
      end

    find_reflection(flip_image(image), column_reflection_to_ignore)
  end

  def find_reflection(image, reflection_to_ignore = nil)
    (0...(image.size - 1)).each do |reflection|
      if (0..reflection).all? { |dr| reflection + dr + 1 >= image.size || image[reflection - dr] == image[reflection + dr + 1] }
        result = reflection + 1
        return result unless result == reflection_to_ignore
      end
    end

    nil
  end

  def flip_image(image)
    image2 = image.first.size.times.map { '' }

    image.each do |line|
      line.split('').each_with_index do |char, x|
        image2[x] += char
      end
    end

    image2
  end
end
