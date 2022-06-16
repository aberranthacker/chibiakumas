#!/bin/ruby
# frozen_string_literal: true

require_relative 'disk_map.rb'

FILLER = '#'.ord

sectors_in_total = 10 * 80 * 2
bytes_in_total = sectors_in_total * 512

col1_width = FILES.map(&:length).max
dsk = []

binaries_info = File.read('build/binaries_info.txt').lines
bytes_used = 0
sectors_used = 0

puts "#{' ' * col1_width}  entry   size    end blocks block"
print_info = lambda do |file_name, bin, target_size| #-----------------------{{{
  binary_info = binaries_info.find { |line| line.include?(file_name) }
  if binary_info.nil?
    puts "#{file_name.ljust(col1_width, ' ')} " \
         "#{' ' * 6} " \
         "#{bin.size.to_s.rjust(6, ' ')} " \
         "#{' ' * 6} " \
         "#{(target_size / 512).to_s.rjust(6, ' ')} " \
         "#{sectors_used.to_s.rjust(5, ' ')} "
    bytes_used += bin.size
  else
    puts "#{file_name.ljust(col1_width, ' ')} " \
         "#{binary_info.split(',')[1].rjust(6, ' ')} " \
         "#{binary_info.split(',')[2].rjust(6, ' ')} " \
         "#{binary_info.split(',')[3].chomp.rjust(6, ' ')} " \
         "#{(target_size / 512).to_s.rjust(6, ' ')} " \
         "#{sectors_used.to_s.rjust(5, ' ')} "
    bytes_used += binary_info.split(',')[2].to_i
  end
end #------------------------------------------------------------------------}}}

FILES.each do |file_name|
  bin = File.binread(file_name).unpack('C*')
  target_size = (bin.size + 511) / 512 * 512

  print_info.call(file_name, bin, target_size)
  sectors_used += (target_size / 512)

  bin += Array.new(target_size - bin.size, FILLER)
  dsk += bin
end

dsk += Array.new(bytes_in_total - dsk.size, FILLER)
File.binwrite('build/chibiakumas.dsk', dsk.pack('C*'))

puts "#{' ' * col1_width} " \
     "#{' ' * 6} " \
     "#{bytes_used.to_s.rjust(6, ' ')} " \
     "#{' ' * 6} " \
     "#{sectors_used.to_s.rjust(6, ' ')}"

