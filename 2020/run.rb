day, part = ARGV.map(&:to_i)

if day.nil? || day >= 6
  if day.nil?
    day = Time.now.day
  end

  part ||= 2

  begin
    require "#{File.dirname(__FILE__)}/programs/#{sprintf('%02d', day)}#{sprintf('%02d', part)}.rb"
  rescue LoadError => e
    if part == 2
      part = 1
      retry
    end

    puts "Could not find day #{day}, part #{part}"
    exit
  end

  input =
    File
      .read("#{File.dirname(__FILE__)}/inputs/#{sprintf('%02d', day)}.txt")
      .lines
      .map(&:strip)

  puts Response.new.call(input)
  exit
end

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
