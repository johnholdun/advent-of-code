slug = ARGV[0]

begin
  require "#{File.dirname(__FILE__)}/programs/#{slug}.rb"
rescue LoadError => e
  puts "Could not find slug #{slug}"
  exit 1
end

unless defined?(Response)
  puts "Expected #{slug}.rb to define a class called Response but it didn't :/"
  exit 1
end

input_filename = "#{File.dirname(__FILE__)}/inputs/#{slug[0, 2]}.txt"

unless File.exist?(input_filename)
  puts "Could not find input for slug #{slug}"
  exit 1
end

input = File.read(input_filename).lines.map(&:rstrip)

puts Response.new.call(input)
