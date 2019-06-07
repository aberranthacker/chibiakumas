require 'pry'
require 'optparse'
require_relative './preprocessor/str_to_radix50.rb'

options = Struct.new(:filename).new
OptionParser.new do |opts|
  opts.banner = "Usage: ruby preprocessor.rb FILENAME"
  options.filename = opts.default_argv[0]
end

exit unless options.filename

File.open(options.filename).each_line do |line|
  if (match = /^(\s*)\.RADIX50\s+"([ A-Z$.0-9]+)".*/i.match(line))
    puts "#{match[1]}.byte #{StrToRadix50.call(match[2]).join(', ')} # #{match[0].strip}"
  else
    puts line
  end
end

StrToRadix50.test
