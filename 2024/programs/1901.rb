# *phoenix voice*
class Response
  def call(input)
    towels = input.shift.split(', ')
    input.shift
    designs = input
    @possible = designs.sort_by(&:size)

    designs.count { |design|
      print "hmm #{design}…"
      result = doable?(design, towels)
      puts result
      result
    }
  end

  private

  def doable?(design, towels)
    return true if @possible.include?(design)
    candidates = ['']

    loop do
      print "(#{candidates.size})…"
      new_candidates = []
      candidates.each do |candidate|
        towels.each do |towel|
          maybe = "#{candidate}#{towel}"
          new_candidates.push(maybe) if design.start_with?(maybe)
        end
      end

      return true if new_candidates.include?(design)
      return false if new_candidates.size.zero?
      candidates = new_candidates
    end

    false
  end
end
