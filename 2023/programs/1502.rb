class Response
  def call(input)
    boxes = 256.times.map { [] }

    input
      .first
      .split(',')
      .map do |string|
        _, label, operation, focal_length = string.match(/^([a-z]+)([-=])(\d+)?/).to_a
        focal_length = focal_length.to_i if focal_length

        box = 0
        label.chars.each do |char|
          box = ((box + char.ord) * 17) % 256
        end

        case operation
        when '-'
          boxes[box].reject! { |lens_label, _| lens_label == label }
        when '='
          found = false

          boxes[box].each_with_index do |(lens_label, _), index|
            if lens_label == label
              found = true
              boxes[box][index][1] = focal_length
            end
          end

          unless found
            boxes[box].push([label, focal_length])
          end
        else
          raise "uhhh #{string}"
        end
      end

    value = 0

    boxes.each_with_index do |box, box_index|
      box.each_with_index do |(_label, focal_length), lens_index|
        this = (box_index + 1) * (lens_index + 1) * focal_length
        value += this
      end
    end

    value
  end
end
