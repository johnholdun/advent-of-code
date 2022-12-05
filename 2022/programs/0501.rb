class Response
  def call(input)
    raw_stacks, steps = input.slice_when { |a, _| a.empty? }.to_a

    stacks = []

    raw_stacks.each do |slice|
      slice.split('').each_slice(4).each_with_index do |item, index|
        (stacks[index] ||= []).unshift(item[1]) unless item[1].empty?
      end
    end

    stacks.each(&:shift).map! { |a| a.reject { |i| i == ' ' } }

    steps.each do |step|
      count, from, to = step.scan(/move (\d+) from (\d+) to (\d+)/).to_a.flatten.map(&:to_i)
      count.times do
        stacks[to - 1].push(stacks[from - 1].pop)
      end
    end

    stacks.map(&:last).reject(&:empty?).join('')
  end
end
