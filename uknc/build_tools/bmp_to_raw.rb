#!/usr/bin/ruby

require 'optparse'

options = Struct.new(:bpp, :verbose, :src_filename, :dst_filename)
                .new(2, false, nil, nil)

OptionParser.new do |opts|
  opts.banner = 'Converts 8bpp .bmp file to the Elektronika MS 0511 raw bitplanes data'
  opts.banner = 'only first 1, 2 or 3 bits of colors will be used'
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
# https://en.wikipedia.org/wiki/BMP_file_format
bmp = File.binread(options.src_filename)

signature          = bmp[0,2]
pixel_array_offset = bmp[0x0A,4].unpack1('V') # 32-bit unsigned, VAX (little-endian) byte order
image_width        = bmp[0x12,4].unpack1('V') # 32-bit unsigned, VAX (little-endian) byte order
image_height       = bmp[0x16,4].unpack1('V') # 32-bit unsigned, VAX (little-endian) byte order
planes             = bmp[0x1A,2].unpack1('v') # 16-bit unsigned, VAX (little-endian) byte order
bits_per_pixel     = bmp[0x1C,2].unpack1('v') # 16-bit unsigned, VAX (little-endian) byte order
compression        = bmp[0x1E,4].unpack1('V') # 32-bit unsigned, VAX (little-endian) byte order
image_size         = bmp[0x22,4].unpack1('V') # 32-bit unsigned, VAX (little-endian) byte order

raise "#{options.src_filename} : Unknown file type." unless signature == 'BM'
raise "#{options.src_filename} : Number of color planes other than 1 in not supported." unless planes == 1
unless [4, 8].include?(bits_per_pixel)
  raise "#{options.src_filename} : #{bits_per_pixel} bits per pixel not supported, 4 or 8 bits only."
end
if bits_per_pixel < options.bpp
  raise "#{options.src_filename} has #{bits_per_pixel}bpp, which is less than resulting #{options.bpp}bpp."
end
raise "#{options.src_filename} : Compression is not supported." unless compression == 0
if image_width % 8 != 0
  puts "#{options.src_filename} \u001b[31;1mWARNING\u001b[0m: " \
       "Image width #{image_width} is not multiple of 8"
end

row_width = bits_per_pixel * image_width / 8
row_width_with_padding = (bits_per_pixel * image_width + 31) / 32 * 4

bitmap = bmp[pixel_array_offset, image_size].bytes

dst_bitmap = []
bp0_byte = 0
bp1_byte = 0
bp2_byte = 0
bit_number = 0

if bits_per_pixel == 8
  (0...bitmap.length).step(row_width_with_padding).to_a.reverse.each do |row_idx|
    (0...row_width).each do |col_idx|
      bitmap_byte = bitmap[row_idx + col_idx]

      bp0_byte |= (bitmap_byte >> 0 & 1) << bit_number
      bp1_byte |= (bitmap_byte >> 1 & 1) << bit_number
      bp2_byte |= (bitmap_byte >> 2 & 1) << bit_number

      next if (bit_number += 1) < 8

      if options.bpp == 1
        dst_bitmap.push(bp0_byte)
      elsif options.bpp == 2
        dst_bitmap.push(bp1_byte << 8 | bp0_byte)
      elsif options.bpp == 3
        dst_bitmap.push(bp0_byte)
        dst_bitmap.push(bp2_byte << 8 | bp1_byte)
      end

      bit_number = 0
      bp0_byte, bp1_byte, bp2_byte = [0, 0, 0]
    end
  end
elsif bits_per_pixel == 4
  (0...bitmap.length).step(row_width_with_padding).to_a.reverse.each do |row_idx|
    (0...row_width).each do |col_idx|
      bitmap_byte = bitmap[row_idx + col_idx]

      nibble = bitmap_byte >> 4
      bp0_byte |= (nibble >> 0 & 1) << bit_number
      bp1_byte |= (nibble >> 1 & 1) << bit_number
      bp2_byte |= (nibble >> 2 & 1) << bit_number

      bit_number += 1
      nibble = bitmap_byte

      bp0_byte |= (nibble >> 0 & 1) << bit_number
      bp1_byte |= (nibble >> 1 & 1) << bit_number
      bp2_byte |= (nibble >> 2 & 1) << bit_number

      next if (bit_number += 1) < 8

      if options.bpp == 1
        dst_bitmap.push(bp0_byte)
      elsif options.bpp == 2
        dst_bitmap.push(bp1_byte << 8 | bp0_byte)
      elsif options.bpp == 3
        dst_bitmap.push(bp0_byte)
        dst_bitmap.push(bp2_byte << 8 | bp1_byte)
      end

      bit_number = 0
      bp0_byte, bp1_byte, bp2_byte = [0, 0, 0]
    end
  end
end

bin = if options.bpp == 1
        dst_bitmap.pack('C*') # 8-bit unsigned (unsigned char)
      else
        dst_bitmap.pack('v*') # 16-bit unsigned, VAX (little-endian) byte order
      end
File.binwrite(options.dst_filename, bin)

if options.verbose
  puts "#{options.src_filename} #{image_width}x#{image_height} #{options.bpp}bpp converted"
end
