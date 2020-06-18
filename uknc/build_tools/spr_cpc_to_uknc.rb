#!/usr/bin/ruby
#
# Binary Sprite file format (CPC/ENT/ZX/SAM)
#
#     Akusprite files that have been saved for a platform such as the CPC will
# have a header... this header has 6 bytes per sprite... the length of the
# header can vary, it just needs to be big enough to hold all the sprites
#
# Byte 0 is the height of the sprite data in lines
# Byte 1 is the Width of the sprite in bytes
# Byte 2 is the Y offset...
#        a 16 pixel sprite may have 4 blank lines at the top
#        in this case the sprite would have a height of 12 and an offset of 4
#        this is to save memory
# Byte 3 is the Settings
#        the top bit (7) defines if the sprite is transparent (slow) or PSET
#        (fast)
#        bit 5 defines if the sprite changes or accepts the background color on
#        the speccy
#        other bits also select the transparent color (bytemask) on cpc
# Bytes 4,5 define the offset to the bitmap data of the sprite in the file
#        in this case the sprite starts at &0100... this is defined in the
#        spriteeditor by 'SpriteDataOffset' in the Spritelist tab
#
# These 6 bytes will be repeated for the next sprite, and so on

require 'optparse'
require_relative 'reverse_tables'

options = Struct.new(:in_filename, :out_filename, :font).new

OptionParser.new do |opts|
  opts.banner = 'Usage: cpc_to_uknc_sprites.rb FILENAME'
  options.in_filename = opts.default_argv[0]

  opts.on('-o NAME', '--out-file=NAME", "output filename') do |v|
    options.out_filename = v
  end

  opts.on('--font', 'Font conversion. No header, all sprites 8 lines high.') do
    options.font = true
  end
end.parse!

def transform(sprite_words)
  [].tap do |words|
    sprite_words.each do |word|
      nibble1 = REVERSE_TABLE_4BIT[(word & 0x000F)]
      nibble2 = REVERSE_TABLE_4BIT[(word & 0x00F0) >> 4]
      nibble3 = REVERSE_TABLE_4BIT[(word & 0x0F00) >> 8]
      nibble4 = REVERSE_TABLE_4BIT[(word & 0xF000) >> 12]

      # words << (nibble4 << 12 | nibble2 << 8 | nibble3 << 4 | nibble1)
      words << (nibble3 << 12 | nibble1 << 8 | nibble4 << 4 | nibble2)
    end
  end
end

file = File.binread(options.in_filename)
file = file[0x80, file.size - 0x80] if file[0].ord.zero?

data_offset = file[4, 2].unpack1('v')
header = []

0.step(data_offset - 6, 6).each.with_index do |i, idx|
  rec = {
    idx: idx,
    height: file[i].ord,
    width: file[i + 1].ord,
    y_offset: file[i + 2].ord,
    settings: file[i + 3].ord,
    offset: file[i + 4, 2].unpack1('v')
  }
  rec[:y_offset] = 7 if rec[:y_offset] == 255

  break if rec[:height].zero?

  header << rec
end

diff = data_offset - (header.size * 6)

new_file = ''

header.each do |rec|
  values = rec.values_at(:height, :width, :y_offset, :settings, :offset)
  values[-1] = values[-1] - diff

  new_file << values.pack('CCCCv')
end

new_file = '' if options.font

header.each do |md|
  print "i: #{md[:idx].to_s.rjust(3, ' ')} "
  print "h: #{md[:height].to_s.rjust(3, ' ')} "
  print "w: #{md[:width].to_s.rjust(2, ' ')} "
  print "y_offset: #{md[:y_offset].to_s.rjust(2, ' ')} "
  print "settings: #{md[:settings].to_s.rjust(3, ' ')} "
  puts  "offset: #{md[:offset]}"

  sprite = file[md[:offset], md[:height] * md[:width]].unpack('v*')
  uknc_sprite = []

  if options.font
    md[:y_offset].times { uknc_sprite << 0 }
    uknc_sprite += transform(sprite)
    (8 - md[:height] - md[:y_offset]).times { uknc_sprite << 0 }

    bytes = uknc_sprite.map { |word| (word & 0xFF) | (word >> 8) }

    new_file << bytes.pack('C*')
  else
    uknc_sprite = transform(sprite)

    new_file << uknc_sprite.pack('v*')
  end
end

File.binwrite(options.out_filename, new_file)
