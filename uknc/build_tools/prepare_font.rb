require_relative 'reverse_tables'

bmp = File.binread('./resources/cga8x8b.bmp.raw').bytes.reverse

(0...bmp.length).step(32).each do |idx|
  line = bmp[idx,32].reverse
  bmp[idx, 32] = line.map { |i| REVERSE_TABLE_8BIT[i].chr }
end

font = []
4.times do |line|
  32.times do |char|
    8.times do |char_line|
      font << bmp[(256 * line) + char + (32 * char_line)]
    end
  end
end

File.binwrite('./resources/cga8x8b.raw', font.join)

