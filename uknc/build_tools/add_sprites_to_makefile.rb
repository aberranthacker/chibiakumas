#!/usr/bin/ruby

require 'pathname'
require 'fileutils'

BMP_TO_RAW = 'build_tools/bmp_to_raw.rb'
sprites_dir = ARGV[0]
level_name = Pathname.new(sprites_dir).split.last.to_s

makefile_lines = File.read('Makefile').lines

4.times do
  start_idx = makefile_lines.find_index { |line| /# #{level_name}\.\d\.spr.+{{{/.match?(line) }
  end_idx   = makefile_lines.find_index { |line| /# #{level_name}\.\d\.spr.+}}}/.match?(line) }
  unless start_idx.nil? && end_idx.nil?
    makefile_lines = makefile_lines[0..start_idx-2] + makefile_lines[end_idx+1..-1]
  end
end

def generate_spr_block(sprites_dir, level_name, idx)
  result = []
  file_names = Dir.glob("#{sprites_dir}/*.#{idx}.bmp").map do |path|
    Pathname.new(path).basename.to_s[0..-5]
  end.sort

  spr_file_name = "#{level_name}.#{idx}.spr"
  spr_pathname = File.join('build', spr_file_name)
  result << "\n"
  result << "# #{spr_file_name} #{'-' * (80 - spr_file_name.length - 6)}{{{\n"

  object_pathname = File.join('build', "#{level_name}.#{idx}.o")
  linker_script_filename = 'linker_scripts/sprites.cmd'
  result << "#{spr_pathname} : #{object_pathname} \\\n"
  result << "#{' ' * spr_pathname.length}   #{linker_script_filename}\n"
  result << "\t$(LD) $(LDFLAGS) #{object_pathname} -T #{linker_script_filename} \\\n"
  result << "\t                 -o #{spr_pathname}\n"
  result << "\n"

  source_filename = "#{level_name}.#{idx}.s"
  result << "#{object_pathname} : #{source_filename} \\\n"
  file_names.each.with_index(1) do |filename, idx|
    bin_pathname = File.join('build', level_name, "#{filename}.bin")
    if idx == file_names.length
      result << "\t#{' ' * (object_pathname.length - 8)}   #{bin_pathname}\n"
    else
      result << "\t#{' ' * (object_pathname.length - 8)}   #{bin_pathname} \\\n"
    end
  end
  result << "\t$(AS) -al #{source_filename} -o #{object_pathname}\n"

  file_names.each do |filename|
    next if filename.include?(level_name)

    result << "\n"

    target_pathname = File.join('build', level_name, "#{filename}.bin")
    result << "#{target_pathname} : #{BMP_TO_RAW} \\\n"

    src_pathname = File.join('resources', level_name, "#{filename}.bmp")
    result << "#{' ' * target_pathname.length}   #{src_pathname}\n"

    if filename.include?('_mask')
      result << "\t#{BMP_TO_RAW} -b 1 #{src_pathname} \\\n"
      result << "\t#{' ' * (BMP_TO_RAW.length + 5)} #{target_pathname}\n"
    else
      result << "\t#{BMP_TO_RAW} #{src_pathname} \\\n"
      result << "\t#{' ' * BMP_TO_RAW.length} #{target_pathname}\n"
    end
  end
  result << "# #{spr_file_name} #{'-' * (80 - spr_file_name.length - 6)}}}}\n"
end

makefile_lines += generate_spr_block(sprites_dir, level_name, 0)
makefile_lines += generate_spr_block(sprites_dir, level_name, 1)

File.write('Makefile', makefile_lines.join)
