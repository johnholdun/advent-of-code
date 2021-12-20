class Response
  def call(input)
    @algorithm = input.shift.split('').map { |c| c == '.' ? 0 : 1 }
    input.shift
    image =
      input.map do |line|
        line.split('').map { |c| c == '.' ? 0 : 1 }
      end

    @generation = 0
    image = 3.times.inject(image) { |image, _| expand(image) }

    # draw(image)
    image2 = enhance(image)
    # draw(image2)
    image3 = enhance(image2)
    # draw(image3)
    image3.flatten.count(1)
  end

  private

  attr_reader :algorithm

  def draw(image)
    image.each do |row|
      row.each do |cell|
        print cell.zero? ? '.' : '#'
      end
      puts
    end
  end

  def expand(image)
    y_margin = [[0] * (image.first.size + 2)]
    y_margin.dup + image.map { |row| [0] + row + [0] } + y_margin.dup
  end

  def enhance(image)
    @generation += 1

    image.size.times.map do |y|
      image.first.size.times.map do |x|
        pixel_at(image, x, y)
      end
    end
  end

  def pixel_at(image, x, y)
    index =
      (-1..1).map do |dy|
        (-1..1).map do |dx|
          nx = x + dx
          ny = y + dy
          if nx < 0 || nx >= image.first.size || ny < 0 || ny >= image.size
            algorithm[0].zero? || @generation % 2 == 1 ? 0 : 1
          else
            image[ny][nx]
          end
        end
      end
      .join('')
      .to_i(2)

    algorithm[index]
  end
end
