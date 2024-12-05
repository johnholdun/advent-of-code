class Response
  def call(input)
    rules = {}
    updates = []
    in_rules = true

    input.each do |line|
      if line == ''
        in_rules = false
      elsif in_rules
        before, after = line.split('|').map(&:to_i)
        rules[before] ||= []
        rules[before].push(after)
      else
        updates.push(line.split(',').map(&:to_i))
      end
    end

    updates
      .select do |pages|
        pages.each_with_index.all? do |page, index|
          index == 0 ||
            rules[page].nil? ||
            (rules[page] & pages[0...index]).size.zero?
        end
      end
      .map { |u| u[(u.size / 2.0)] }
      .sum
  end
end
