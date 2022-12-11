class Response
  KEYS = {
    'Starting items' => :holding,
    'Operation' => :operation,
    'Test' => :test,
    'If true' => :true,
    'If false' => :false
  }.freeze

  def call(input)
    monkeys = []

    input.each do |line|
      next if line == ''

      left, right = line.split(':').map(&:strip)
      if left =~ /^Monkey (\d+)$/
        monkeys.push({
          holding: [],
          operation: [],
          test: -1,
          true: -1,
          false: -1,
          inspections: 0
        })
      else
        key = KEYS[left]
        value =
          case key
          when :holding
            right.split(', ').map(&:to_i)
          when :operation
            operand, term = right.sub(/^new = old /, '').split(' ')
            term = term.to_i if term =~ /^\d+$/
            [operand, term]
          when :test
            right.sub(/^divisible by /, '').to_i
          when :true, :false
            right.sub(/^throw to monkey /, '').to_i
          end
        monkeys.last[key] = value
      end
    end

    10000.times do |round|
      monkeys.each_with_index do |monkey, index|
        next if monkey[:holding].size.zero?
        monkey[:holding].size.times do
          worry = monkey[:holding].shift
          operand, value = monkey[:operation]
          value = worry if value == 'old'
          worry =
            case operand
            when '*' then worry * value
            when '+' then worry + value
            end
          outcome = worry % monkey[:test] == 0
          next_monkey = monkey[outcome ? :true : :false]
          # It does not make sense to me that this modulus works, specifically
          # for the `new = old * old` operation, but it does so idk
          worry %= monkeys.map { |m| m[:test] }.inject(:*)
          monkeys[next_monkey][:holding].push(worry)
          monkey[:inspections] += 1
        end
      end
    end

    monkeys.map { |m| m[:inspections] }.sort.last(2).reduce(:*)
  end
end
