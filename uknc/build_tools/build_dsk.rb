#!/usr/bin/ruby

require_relative 'dsk_image_constants'

module BuildDskImage
  extend self

  def call(dsk_files_list, output_file_name)
    col1_width = dsk_files_list.map(&:length).max
    dsk = []

    bytes_used = 0
    sectors_used = 0

    puts "#{' ' * col1_width}                57344"
    puts "#{' ' * col1_width}  entry   size    end   free blocks block"

    dsk_files_list.each do |file_name|
      bin = File.binread(file_name).unpack('C*')
      target_size = (bin.size + 511) / 512 * 512

      print_info(file_name, bin, target_size, sectors_used, col1_width)

      bytes_used += bin.size
      sectors_used += (target_size / 512)

      bin += Array.new(target_size - bin.size, FILLER)
      dsk += bin
    end

    dsk += Array.new(BYTES_IN_TOTAL - dsk.size, FILLER)
    File.binwrite(output_file_name, dsk.pack('C*'))

    puts "#{' ' * col1_width} " \
         "#{' ' * 6} " \
         "#{bytes_used.to_s.rjust(6, ' ')} " \
         "#{' ' * 6} " \
         "#{' ' * 6} " \
         "#{sectors_used.to_s.rjust(6, ' ')}"
  end

  private

  def print_info(file_name, bin, target_size, sectors_used, col1_width)
    binary_info = if File.exist?("#{file_name}._")
                    File.read("#{file_name}._").split(',')
                  else
                    nil
                  end

    puts [
      file_name.ljust(col1_width, ' '),
      entry_address_str(binary_info),
      bin_size_str(binary_info, bin),
      ending_address_str(binary_info),
      free_ram_str(binary_info, bin),
      (target_size / 512).to_s.rjust(6, ' '),
      sectors_used.to_s.rjust(5, ' ')
    ].join(' ')
  end

  def entry_address_str(binary_info)
    return ' ' * 6 if binary_info.nil?

    binary_info[0].rjust(6, ' ')
  end

  def bin_size_str(binary_info, bin)
    return bin.size.to_s.rjust(6, ' ') if binary_info.nil?

    binary_info[1].rjust(6, ' ')
  end

  def ending_address_str(binary_info)
    return ' ' * 6 if binary_info.nil?

    ending_address = binary_info[2].chomp.to_i
    str = ending_address.to_s.rjust(6, ' ')
    return str unless ending_address >= 56*1024
    return "\u001b[31m#{str}\u001b[0m" unless ending_address >= 63*1024

    "\u001b[31;1m#{str}\u001b[0m"
  end

  def free_ram_str(binary_info, bin)
    return ' ' * 6 if binary_info.nil?

    (56 * 1024 - binary_info[2].to_i).to_s.rjust(6, ' ')
  end
end

BuildDskImage.call(File.readlines(ARGV[0]).map(&:chomp), ARGV[1])
