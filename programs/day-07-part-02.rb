require './day'

class Day7Part2 < Day
  DAY = 7
  PART = 2

  Step = Struct.new(:id, :duration, :requirements, :worker, :start)

  def call
    workers = 5
    time = 0
    done = []
    jobs = []

    begin
      done = steps.select { |s| s.start && s.duration + s.start <= time }

      steps_in_progress =
        steps.select { |s| s.start && s.duration + s.start > time }

      if steps_in_progress.size < workers
        available_steps =
          steps.select do |step|
            step.start.nil? &&
            (step.requirements & done.map(&:id)).size == step.requirements.size
          end

        available_steps[0, (workers - steps_in_progress.size)].each_with_index do |step, index|
          step.start = time
        end
      end

      break if steps.all? { |s| s.start + s.duration <= time }

      time += 1
    end while true

    time
  end

  private

  def steps
    @steps ||= generate_steps
  end

  def generate_steps
    letters = ('A'..'Z').to_a

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

    order.each_with_index.map do |id, index|
      Step.new \
        id,
        letters.index(id) + 61,
        requirements[id],
        nil
    end
  end
end
