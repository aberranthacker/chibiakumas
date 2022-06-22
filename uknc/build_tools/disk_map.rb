#!/bin/ruby
# frozen_string_literal: true

require_relative 'dsk_image_constants'

binaries_info = File.read('build/binaries_info.txt').each_line.map do |line|
  data = line.split(',')
  file_name = data[0][%r{build/(.+)}, 1]
  file_size = data[2].to_i
  { file_name: file_name, file_size: file_size }
end

bootstrap_s = File.read('bootstrap.s').lines

binaries_info.each do |binary_info|
  next if %w[bootsector.bin bootstrap.bin].include?(binary_info[:file_name])

  idx = bootstrap_s.find_index do |line|
    line.match?(%r{^#{binary_info[:file_name]}:})
  end

  if idx.nil?
    puts "bootstrap.s: label #{binary_info[:file_name]}: is missing"
    next
  end

  bootstrap_s[idx + 2] = "    .equiv #{binary_info[:file_name].split('.')[0]}_size, " \
                                    "#{binary_info[:file_size]}\n"
end

File.write('bootstrap.s', bootstrap_s.join)
