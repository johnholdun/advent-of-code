class Response
  def call(input)
    sequence = input.shift.split('')

    @pairs =
      sequence
      .each_cons(2)
      .each_with_object(Hash.new(0)) do |pair, hash|
        hash[pair.join] ||= 0
        hash[pair.join] += 1
      end
    input.shift
    @rules = input.map { |i| i.split(' -> ') }.to_h

    40.times { tick! }
    freqs =
      @pairs.keys.join('').split('').uniq.each_with_object({}) do |letter, hash|
        hash[letter] = @pairs.keys.select { |k| k.start_with?(letter) }.map { |k| @pairs[k] }.inject(:+)
        hash[letter] += 1 if sequence.last == letter
      end
    counts = freqs.values.sort
    counts.last - counts.first
  end

  private

  def tick!
    new_pairs = Hash.new(0)
    @pairs.each do |pair, count|
      if @rules[pair]
        a, c = pair.split('')
        b = @rules[pair]
        new_pairs[[a, b].join] += count
        new_pairs[[b, c].join] += count
      else
        new_pairs[pair] += count
      end
    end
    @pairs = new_pairs
  end
end
