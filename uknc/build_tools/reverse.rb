bmp = File.binread('./cga8x8b.bmp.raw').chars.reverse

(0...bmp.length).step(32).each do |idx|
  line = bmp[idx,32].reverse
  bmp[idx, 32] = line.map { |i| i.ord.to_s(2).rjust(8, '0').chars.reverse.join.to_i(2).chr }
end

File.binwrite('./cga8x8b.raw', bmp.join)

