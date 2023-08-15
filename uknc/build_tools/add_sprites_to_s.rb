#!/usr/bin/ruby

require 'pathname'
require 'fileutils'

sprites_dir = ARGV[0]
level_name = Pathname.new(sprites_dir).split.last.to_s

4.times do |i|
  filename = "#{level_name}.#{i}.s"
  FileUtils.rm(filename) if File.exists?(filename)
end

def generate_s_file(sprites_dir, level_name, s_file_idx)
  File.open("#{level_name}.#{s_file_idx}.s", 'w') do |f|
    f.puts('    .nolist')
    f.puts('    .include "./core_defs.s"')
    f.puts
    f.puts('   # sprite 0 Dummy sprite')
    f.puts('    .word 0  # sprite offset')
    f.puts('    .word 0  # bit-mask offset')
    f.puts('    .byte 0  # height of the sprite')
    f.puts('    .byte 0  # Y offset')
    f.puts('    .byte 6  # width')
    f.puts('    .byte SPR_TURBO  # attributes')
    f.puts

    spritenames = Dir.glob("#{sprites_dir}/*.#{s_file_idx}.bmp").map do |path|
      Pathname.new(path).basename.to_s[0..-7]
    end.sort

    sprite_idx = 1
    spritenames.each do |spritename|
      next if spritename.include?('_mask')

      bmp = File.binread(File.join(sprites_dir, "#{spritename}.#{s_file_idx}.bmp"))
      image_width        = bmp[0x12,4].unpack1('V')
      image_height       = bmp[0x16,4].unpack1('V')

      spritename_camelcase = spritename.split('_').map(&:capitalize).join
      f.puts("   # sprite #{sprite_idx} #{spritename_camelcase}")
      f.puts("    .word #{spritename_camelcase} # sprite offset")
      if spritenames.include?("#{spritename}_mask")
        f.puts("    .word #{spritename_camelcase}Mask # bit-mask offset")
      else
        f.puts("    .word 0 # bit-mask offset")
      end
      f.puts("    .byte #{image_height} # height of the sprite")
      f.puts("    .byte 0 # Y offset")
      f.puts("    .byte #{image_width / 4} # witdh")
      if spritenames.include?("#{spritename}_mask")
        f.puts("    .byte SPR_HAS_MASK # attributes")
      else
        f.puts("    .byte SPR_TURBO # attributes")
      end
      f.puts

      sprite_idx += 1
    end

    spritenames.each do |spritename|
      next if spritename.include?('_mask')

      spritename_camelcase = spritename.split('_').map(&:capitalize).join
      f.puts("#{spritename_camelcase}:")
      bin_filename = File.join('build', level_name, "#{spritename}.#{s_file_idx}.bin")
      f.puts(%(    .incbin "#{bin_filename}"))

      if spritenames.include?("#{spritename}_mask")
        f.puts("#{spritename_camelcase}Mask:")
        bin_mask_filename = File.join('build', level_name, "#{spritename}_mask.#{s_file_idx}.bin")
        f.puts(%(    .incbin "#{bin_mask_filename}"))
        f.puts(%(    .even))
      end
      f.puts
    end
  end
end

generate_s_file(sprites_dir, level_name, 0)
generate_s_file(sprites_dir, level_name, 1)
