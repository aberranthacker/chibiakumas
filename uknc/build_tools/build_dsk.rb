#!/bin/ruby
# frozen_string_literal: true

FILLER = 0xFF

sectors_in_total = 10 * 80 * 2
bytes_in_total = sectors_in_total * 512

files = [
  'build/bootsector.bin',
  'build/bootstrap.bin',
  'build/ppu_module.bin',
  'build/loading_screen.bin',
  'build/core.bin',
  'build/level-00.bin',
  'build/ep1-intro.bin',
  'build/ep1-intro-slides.bin'
]

dsk = []

files.each do |file_name|
  bin = File.binread(file_name).unpack('C*')
  target_size = (bin.size + 511) / 512 * 512
  bin += Array.new(target_size - bin.size, FILLER)

  dsk += bin
end

dsk += Array.new(bytes_in_total - dsk.size, FILLER)

File.binwrite('build/chibiakumas.dsk', dsk.pack('C*'))
