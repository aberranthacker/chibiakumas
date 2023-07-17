#!/usr/bin/ruby

require 'optparse'
require_relative 'dsk_image_constants'

options = Struct.new(:fileslist_filename, :map_filename, :updated_filename, :entry).new

OptionParser.new do |opts|
  opts.banner = 'Usage: update_disk_map.rb FILESLIST_FILENAME MAP_FILENAME UPDATED_FILENAME --entry n'
  options.fileslist_filename = opts.default_argv[0]
  options.map_filename = opts.default_argv[1]
  options.updated_filename = opts.default_argv[2]

  opts.on('-e ADDR', '--entry ADDR", "binary file entry point') do |n|
    options.entry = n.to_i
  end
end.parse!

fileslist = File.readlines(options.fileslist_filename).map(&:chomp)

metadata = fileslist.map do |filename|
  [filename[6..-1], { address: 0, size: File.size(filename) }]
end.to_h

File.read(options.map_filename).each_line do |line|
  fileslist.each do |file_name|
    key = file_name[6..-1]
    if /0x\p{XDigit}{16}\s+#{key}/.match?(line)
      metadata[key].update(address: line[/0x\p{XDigit}{16}/].to_i(16))
    end
  end
end

bootstrap_bin = File.binread(options.updated_filename).unpack('v*')

current_block_num = 0

metadata.each do |label, data|
  address = data[:address]
  size = data[:size]

  unless address.zero?
    offset = address / 2
    offset -= options.entry / 2 unless options.entry.nil?

    bootstrap_bin[offset + 1] = (size + 1) / 2
    bootstrap_bin[offset + 2] = current_block_num
  end

  current_block_num += (size + 511) / 512
end

File.binwrite(options.updated_filename, bootstrap_bin.pack('v*'))
