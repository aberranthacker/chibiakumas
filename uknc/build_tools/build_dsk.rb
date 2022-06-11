#!/bin/ruby
# frozen_string_literal: true

FILLER = '#'.ord

sectors_in_total = 10 * 80 * 2
bytes_in_total = sectors_in_total * 512

files = [
  'build/bootsector.bin',
  'build/bootstrap.bin',
  'build/ppu_module.bin',
  'build/loading_screen.bin',
  'build/core.bin',
  'build/ep1-intro.bin',
  'build/ep1-intro-slides.bin',
  'build/level-00.bin',
  'build/level-01.bin'
]
col1_width = files.map(&:length).max
dsk = []
binaries_info = File.read('build/binary_info.txt').lines
puts "#{' ' * col1_width}  entry   size    end sector(s)"

files.each do |file_name|
  bin = File.binread(file_name).unpack('C*')
  target_size = (bin.size + 511) / 512 * 512

  binary_info = binaries_info.find { |line| line.include?(file_name) }
  if binary_info.nil?
    puts "#{file_name.ljust(col1_width, ' ')} " \
         "#{' ' * 6} " \
         "#{bin.size.to_s.rjust(6, ' ')} " \
         "#{' ' * 6} " \
         "#{(target_size / 512).to_s.rjust(4, ' ')}"
  else
    puts "#{file_name.ljust(col1_width, ' ')} " \
         "#{binary_info.split(',')[1].rjust(6, ' ')} " \
         "#{binary_info.split(',')[2].rjust(6, ' ')} " \
         "#{binary_info.split(',')[3].chomp.rjust(6, ' ')} " \
         "#{(target_size / 512).to_s.rjust(4, ' ')}"
  end

  bin += Array.new(target_size - bin.size, FILLER)
  dsk += bin
end

dsk += Array.new(bytes_in_total - dsk.size, FILLER)

File.binwrite('build/chibiakumas.dsk', dsk.pack('C*'))
