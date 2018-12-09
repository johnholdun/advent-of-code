require './day'

class Day7Part1 < Day
  DAY = 7
  PART = 1

  def call
    instructions =
      input.map do |text|
        text.scan(/Step (.) must be finished before step (.) can begin./)[0]
      end

    steps = instructions.flatten.sort.uniq

    requirements =
      steps.each_with_object({}) do |step, hash|
        hash[step] = instructions.select { |_, s| s == step }.map(&:first)
      end

    order = []

    begin
      available_steps =
        steps.select do |step|
          step_reqs = requirements[step]
          step_reqs.size.zero? || step_reqs.all? { |s| order.include?(s) }
        end
      step = available_steps.first
      order.push(step)
      steps.reject! { |s| s == step }
    end while steps.size > 0

    order.join
  end
end
