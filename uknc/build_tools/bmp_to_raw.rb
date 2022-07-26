#!/usr/bin/ruby

require 'optparse'

options = Struct.new(:src_filename, :dst_filename, :bits).new

OptionParser.new do |opts|
  opts.banner = 'Converts 8bpp .bmp file to MS0511 raw bitplanes data'
  opts.banner = 'only first 2 or 3 bits of color will be used'
  opts.banner = 'Usage: bmp_to_raw.rb SRC DST [--bits=n]'
  options.src_filename = opts.default_argv[0]
  options.dst_filename = opts.default_argv[1]

  opts.on('-b n', '--bits=n', 'number of bits') do |n|
    options.bits = n.to_i
  end
end.parse!

# https://github.com/bordeeinc/bmp-ruby
bmp = File.binread(options.src_filename)

signature          = bmp[0,2]
pixel_array_offset = bmp[0x0A,4].unpack1('V')
image_width        = bmp[0x12,4].unpack1('V')
image_height       = bmp[0x16,4].unpack1('V')
planes             = bmp[0x1A,2].unpack1('v')
bits_per_pixel     = bmp[0x1C,2].unpack1('v')
compression        = bmp[0x1E,4].unpack1('V')
image_size         = bmp[0x22,4].unpack1('V')

raise 'Unknown file type.' unless signature == 'BM'
raise 'Number of color planes other than 1 in not supported.' unless planes == 1
raise "#{bits_per_pixel} bits per pixel not supported, 8 bits only." unless bits_per_pixel == 8
raise 'Compression is not supported.' unless compression == 0
raise 'Padded pixel array is not supported.' unless image_width * image_height == image_size

bitmap = bmp[pixel_array_offset, image_size].bytes.reverse

(0...bitmap.length).step(image_width).each do |idx|
  bitmap[idx, image_width] = bitmap[idx, image_width].reverse
end

dst_bitmap = []
bp0_byte = 0
bp1_byte = 0
bp2_byte = 0

bitmap.each.with_index do |byte_pixel, idx|
  bit_number = idx % 8

  bit0 = byte_pixel & 1
  bit1 = byte_pixel >> 1 & 1
  bit2 = byte_pixel >> 2 & 1

  bp0_byte |= bit0 << bit_number
  bp1_byte |= bit1 << bit_number
  bp2_byte |= bit2 << bit_number

  next unless bit_number == 7

  if options.bits == 3
    dst_bitmap.push(bp0_byte)
    dst_bitmap.push(bp2_byte << 8 | bp1_byte)
  else
    dst_bitmap.push(bp0_byte << 8 | bp1_byte)
  end

  bp0_byte = 0
  bp1_byte = 0
  bp2_byte = 0
end

File.binwrite(options.dst_filename, dst_bitmap.pack('v*'))

puts "#{options.src_filename} #{image_width}x#{image_height} converted"
puts
