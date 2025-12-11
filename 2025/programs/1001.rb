class Response
  def call(input)
    input
      .map do |line|
        goal_string, presses_string = line.scan(/^\[(.+)\] ((?:\([0-9,]+\) )+){.+}$/).first
        goal = goal_string.split('').map { |c| c == '#' }
        presses = presses_string.scan(/\(([\d,]+)\)/).flatten.map { |s| s.split(',').map(&:to_i) }

        states = { goal.count.times.map { false } => 0 }

        catch(:counting) do
          loop do
            states.keys.each do |state|
              presses.each do |toggles|
                count = states[state]
                new_state = state.each_with_index.map { |s, i| toggles.include?(i) ? !s : s }
                states[new_state] ||= count + 1
                throw(:counting) if new_state == goal
              end
            end
          end
        end

        states[goal]
      end
      .sum
  end
end
