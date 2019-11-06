require 'optparse'
require_relative './preprocessor/str_to_radix50.rb'

options = Struct.new(:filename, :process_all_files).new
OptionParser.new do |opts|
  opts.banner = "Usage: ruby preprocessor.rb -i FILENAME"

  opts.on("-i NAME", "--input-file=NAME", "source file to process") do |n|
    options.filename = n
  end

  opts.on('-a', '--all', 'process all *.s files') do
    options.process_all_files = true
  end
end.parse!

exit unless options.filename || options.process_all_files

def process_file(filename)
  data = File.read(filename)
  processed_data = ''
  data.each_line do |line|
    processed_line = if (match = /^(\s*)\.RAD50\s+"([ A-Z$.0-9]+)".*/i.match(line))
                       "#{match[1]}.word #{StrToRadix50.call(match[2]).join(', ')} # #{match[0].strip}\n"
                     else
                       line
                     end
    processed_data << processed_line
  end

  File.write(filename, processed_data) unless processed_data == data
end

if options.process_all_files
  Dir['./**/*.s'].each do |filename|
    process_file(filename)
  end
else
  process_file(options.filename)
end
