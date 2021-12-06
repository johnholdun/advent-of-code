class Response
  def call(input)
    fishes = input.first.split(',').map(&:to_i)

    80.times do
      fishes.size.times do |n|
        if fishes[n].zero?
          fishes[n] = 6
          fishes.push(8)
        else
          fishes[n] -= 1
        end
      end
    end

    fishes.count
  end
end
