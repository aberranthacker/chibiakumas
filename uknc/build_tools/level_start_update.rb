#!/usr/bin/ruby

nm = '~/opt/binutils-pdp11/pdp11-dec-aout/bin/nm'
nm_output = `#{nm} build/core.o -g`
addr = nm_output[/(?<=f{12})[0-9a-f]{4}(?=\sT\sLevelStart)/m].to_i(16)

lines = File.read('core_defs.s').lines.to_a
idx = lines.find_index { |line| /\.equiv Akuyou_LevelStart/.match?(line) }
defs_addr = lines[idx][/(?<=\.equiv Akuyou_LevelStart, 0x)[0-9a-f]{4}/i].to_i(16)

return if addr == defs_addr

hex = "0x#{addr.to_s(16).upcase.rjust(4, '0')}"
oct = "0#{addr.to_s(8)}"
dec = addr
lines[idx] = ".equiv Akuyou_LevelStart, #{hex} # #{dec} #{oct} # auto-generated during a build\n"

File.write('core_defs.s', lines.join)
