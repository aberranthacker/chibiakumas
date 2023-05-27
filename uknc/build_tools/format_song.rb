#!/usr/bin/ruby

src_filename = ARGV[0]
dst_filename = ARGV[1]

src = File.read(src_filename)
pitch_flag = false

File.open(dst_filename, 'w') do |dst|
# dst << "\r\n"
# dst << "        .include \"./core_defs.s\"\r\n"
# dst << "        .global start\r\n"
# dst << "\r\n"
# dst << "        .=PPU_MusicBuffer\r\n"
# dst << "start:\r\n"

  src.lines do |line|
    next if /\.even/.match?(line)

    line = if pitch_flag
             pitch_flag = false
             line.sub('.byte', '.word')
           else
             line
           end


    # .word $ + 2
    line.sub!(/(\s+.word )\$(.+)/, '\1.\2')
    # .word Justaddcream_Pitch1 + 4 * 0 + 1
    line.sub!(/(\.word \w+_Pitch\d+ \+ \d+ \* \d+ \+ )\d+/, '\12')

    dst << line
    dst << "        .even\r\n" if /DisarkPointerRegionStart/.match?(line)
    dst << "        .even\r\n" if /DisarkWordForceReference/.match?(line)

    pitch_flag = true if /^\w+_Pitch\d+:/.match?(line)
  end
  dst << "        .even\r\n"
end
