#!/bin/ruby
# frozen_string_literal: true

require_relative 'dsk_image_constants'

module BuildDskImage
  extend self

  BINARIES_INFO = File.read('build/binaries_info.txt').lines
  COL1_WIDTH = FILES.map(&:length).max

  def call
    dsk = []

    bytes_used = 0
    sectors_used = 0

    puts "#{' ' * COL1_WIDTH}  entry   size    end blocks block"

    FILES.each do |file_name|
      bin = File.binread(file_name).unpack('C*')
      target_size = (bin.size + 511) / 512 * 512

      print_info(file_name, bin, target_size, sectors_used)

      bytes_used += bin.size
      sectors_used += (target_size / 512)

      bin += Array.new(target_size - bin.size, FILLER)
      dsk += bin
    end

    dsk += Array.new(BYTES_IN_TOTAL - dsk.size, FILLER)
    File.binwrite('build/chibiakumas.dsk', dsk.pack('C*'))

    puts "#{' ' * COL1_WIDTH} " \
         "#{' ' * 6} " \
         "#{bytes_used.to_s.rjust(6, ' ')} " \
         "#{' ' * 6} " \
         "#{sectors_used.to_s.rjust(6, ' ')}"
  end

  private

  def print_info(file_name, bin, target_size, sectors_used)
    binary_info = BINARIES_INFO.find { |line| line.include?(file_name) }

    puts [
      file_name.ljust(COL1_WIDTH, ' '),
      entry_address_str(binary_info),
      bin_size_str(binary_info, bin),
      ending_address_str(binary_info),
      (target_size / 512).to_s.rjust(6, ' '),
      sectors_used.to_s.rjust(5, ' ')
    ].join(' ')
  end

  def entry_address_str(binary_info)
    return ' ' * 6 if binary_info.nil?

    binary_info.split(',')[1].rjust(6, ' ')
  end

  def bin_size_str(binary_info, bin)
    return bin.size.to_s.rjust(6, ' ') if binary_info.nil?

    binary_info.split(',')[2].rjust(6, ' ')
  end

  def ending_address_str(binary_info)
    return ' ' * 6 if binary_info.nil?

    ending_address = binary_info.split(',')[3].chomp.to_i
    str = ending_address.to_s.rjust(6, ' ')
    return str unless ending_address >= 56*1024
    return "\u001b[31m#{str}\u001b[0m" unless ending_address >= 63*1024

    "\u001b[31;1m#{str}\u001b[0m"
  end
end

BuildDskImage.call
