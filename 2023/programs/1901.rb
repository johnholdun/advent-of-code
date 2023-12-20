class Response
  def call(input)
    total = 0
    @workflows = {}
    evaluating_workflows = true

    input.each do |line|
      if line == ''
        evaluating_workflows = false
        next
      end

      if evaluating_workflows
        name, rest = line.scan(/^(.+)\{(.+)\}/).to_a.flatten
        steps =
          rest.split(',').map do |step|
            if step =~ /^[a-z]+$/i
              [nil, nil, nil, step]
            else
              parameter, operator, value, destination = step.scan(/(.)(.)(\d+):(.+)/).to_a.flatten
              [parameter, operator, value.to_i, destination]
            end
          end

        @workflows[name] = steps
      else
        part =
          line[1..-2]
            .split(',')
            .map do |param|
              name, value = param.split('=')
              [name, value.to_i]
            end
            .to_h

        total += part.values.sum if accepted?(part)
      end
    end

    total
  end

  private

  attr_reader :workflows

  def accepted?(part)
    process(part, 'in')
  end

  def process(part, workflow_name)
    return true if workflow_name == 'A'
    return false if workflow_name == 'R'

    workflow = workflows[workflow_name]
    raise "uhh #{workflow_name}" unless workflow

    workflow.each do |parameter, operator, value, destination|
      return process(part, destination) if parameter.nil?

      test_value = part[parameter]

      allowed =
        case operator
        when '<'
          test_value < value
        when '>'
          test_value > value
        else
          raise "umm #{workflow_name} #{operator}"
        end

      return process(part, destination) if allowed
    end

    raise 'uhhhh no more workflow'
  end
end
