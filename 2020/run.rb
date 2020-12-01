day, part = ARGV.map(&:to_i)

Dir.glob("#{File.dirname(__FILE__)}/programs/*.rb").each { |f| require(f) }

programs = ObjectSpace.each_object(Day.singleton_class).to_a - [Day]

inputs =
  Dir
    .glob("#{File.dirname(__FILE__)}/inputs/*.txt")
    .each_with_object({}) do |filename, hash|
      key = File.basename(filename).to_i
      hash[key] = File.read(filename).lines.map(&:strip)
    end

klass = programs.find { |d| d::DAY == day && d::PART == part }

puts klass.call(inputs[day])
