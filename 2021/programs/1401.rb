class Response
  def call(input)
    @sequence = input.shift.split('')
    input.shift
    @rules = input.map { |i| a, b = i.split(' -> '); [a.split(''), b] }
    10.times { process! }
    letters = @sequence.uniq
    counts = letters.each_with_object({}) { |l, h| h[l] = @sequence.count(l) }
    sorted_letters = letters.sort_by { |l| counts[l] }
    counts[sorted_letters.last] - counts[sorted_letters.first]
  end

  private

  def process!
    inserts = []
    @rules.each do |pair_check, insertion|
      @sequence.each_cons(2).each_with_index do |pair, index|
        if pair == pair_check
          inserts.push([index + 1, insertion])
        end
      end
    end
    inserts.sort_by(&:first).reverse.each do |index, insertion|
      @sequence.insert(index, insertion)
    end
  end
end
