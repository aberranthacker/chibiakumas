#!/usr/bin/ruby

# https://github.com/bordeeinc/bmp-ruby
bmp = File.binread('resources/menu_cursor-Sheet.bmp')

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
raise 'Number of bits per pixel other than 8 is not supported.' unless bits_per_pixel == 8
raise 'Compression is not supported.' unless compression == 0
raise 'Padded pixel array is not supported.' unless image_width * image_height == image_size

bitmap = bmp[pixel_array_offset, image_size].bytes.reverse

(0...bitmap.length).step(image_width).each do |idx|
  bitmap[idx, image_width] = bitmap[idx, image_width].reverse
end

dst_bitmap = []

lsb = 0
msb = 0
bitmap.each.with_index do |byte_pixel, idx|
  bit_number = idx % 8

  bit1 = byte_pixel & 1
  bit2 = (byte_pixel >> 1) & 1

  lsb = lsb | (bit2 << bit_number)
  msb = msb | (bit1 << bit_number)

  if bit_number == 7
    dst_bitmap << ((msb << 8) | lsb)
    lsb = 0
    msb = 0
  end
end

File.binwrite('resources/menu_cursor.spr', dst_bitmap.pack('v*'))

puts "menu_spite #{image_width}x#{image_height} converted"
puts
