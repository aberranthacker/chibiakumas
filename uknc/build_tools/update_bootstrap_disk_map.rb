#!/bin/ruby
# frozen_string_literal: true

require_relative 'dsk_image_constants'

metadata = FILES.map do |filename|
  [filename[6..-1], { address: 0, size: File.size(filename) }]
end.to_h

File.read('build/bootstrap.map.txt').each_line do |line|
  FILES.each do |file_name|
    key = file_name[6..-1]
    if /0x\p{XDigit}{16}\s+#{key}/.match?(line)
      metadata[key].update(address: line[/0x\p{XDigit}{16}/].to_i(16))
    end
  end
end

bootstrap_bin = File.binread('build/bootstrap.bin').unpack('v*')

current_block_num = 0

metadata.each do |label, data|
  address = data[:address]
  size = data[:size]

  unless address.zero?
    # bootstrap starts from address 384
    # subtract the address to calculate offset
    # and divide by 2 since we dealing with words here
    offset = (address - 512) / 2

    bootstrap_bin[offset+1] = size / 2
    bootstrap_bin[offset+2] = current_block_num
  end

  current_block_num += (size + 511) / 512
end

File.binwrite('build/bootstrap.bin', bootstrap_bin.pack('v*'))
