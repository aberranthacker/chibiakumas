#!/usr/bin/ruby

NM = '~/opt/binutils-pdp11/pdp11-dec-aout/bin/nm'

nm_output = `#{NM} build/ppu.o -g`
lines = File.read('core_defs.s').lines.to_a

addr = nm_output[/[0-9a-f]{8}(?=\sT\sMusicBuffer)/m].to_i(16)
idx = lines.find_index { |line| /\.equiv PPU_MusicBuffer/.match?(line) }
defs_addr = lines[idx][/(?<=\.equiv PPU_MusicBuffer, 0x)[0-9a-f]{4}/i].to_i(16)

return if addr == defs_addr

hex = "0x#{addr.to_s(16).upcase.rjust(4, '0')}"
oct = "0#{addr.to_s(8)}"
dec = addr
lines[idx] = ".equiv PPU_MusicBuffer, #{hex} # #{dec} #{oct} # auto-generated during a build\n"

File.write('core_defs.s', lines.join)
