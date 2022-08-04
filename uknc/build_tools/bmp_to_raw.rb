#!/usr/bin/ruby

require 'optparse'

options = Struct.new(:bpp, :verbose, :src_filename, :dst_filename)
                .new(2, false, nil, nil)

OptionParser.new do |opts|
  opts.banner = 'Converts 8bpp .bmp file to MS0511 raw bitplanes data'
  opts.banner = 'only first 1, 2 or 3 bits of color will be used'
  opts.banner = 'Usage: bmp_to_raw.rb [--bpp=n] SRC DST'

  opts.on('-b n', '--bpp=n', 'resulting number of bits per pixel, default is 2') do |n|
    options.bpp = n.to_i
  end

  opts.on('-v', '--verbose', 'verbose mode') do |n|
    options.verbose = n
  end

  opts.on('-h', '--help') do |_n|
    puts opts
    exit
  end
end.parse!

unless (options.src_filename = ARGV[0])
  puts "ERROR: Need to specify a file to process. Use -h for help"
  exit
end

unless (options.dst_filename = ARGV[1])
  puts "ERROR: Need to specify an output file. Use -h for help"
  exit
end

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
  bit_number = idx % 16 if options.bpp == 1
  bit_number = idx % 8 unless options.bpp == 1

  bit0 = byte_pixel & 1
  bit1 = byte_pixel >> 1 & 1
  bit2 = byte_pixel >> 2 & 1

  bp0_byte |= bit0 << bit_number
  bp1_byte |= bit1 << bit_number
  bp2_byte |= bit2 << bit_number

  next unless (bit_number == 15 && options.bpp == 1) || (bit_number == 7 && options.bpp != 1)

  if options.bpp == 1
    dst_bitmap.push(bp0_byte) # bp0_byte contains a word in this case
  elsif options.bpp == 2
    dst_bitmap.push(bp1_byte << 8 | bp0_byte)
  elsif options.bpp == 3
    dst_bitmap.push(bp0_byte)
    dst_bitmap.push(bp2_byte << 8 | bp1_byte)
  end

  bp0_byte, bp1_byte, bp2_byte = [0, 0, 0]
end

File.binwrite(options.dst_filename, dst_bitmap.pack('v*'))

if options.verbose
  puts "#{options.src_filename} #{image_width}x#{image_height} #{options.bpp}bpp converted"
end
