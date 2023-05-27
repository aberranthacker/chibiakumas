sav = File.binread(ARGV[0])
entry = sav[040, 2].unpack1('v')
eof = sav[050, 2].unpack1('v') + 2

puts "Entry point: #{entry}"
puts "Code size: #{eof - entry} bytes"
puts "End of code block: #{eof}"

body = (eof + 511) / 512
tail = (0x10000 - (body * 512)) / 512

result = ('1' * (body - 1)).to_i(2) << tail

0360.upto(0377).with_index(1) do |addr, index|
  sav[addr] = (result >> ((16 - index) * 8) & 0xFF).chr
  # puts "#{index} - #{sav[addr].ord.to_s(2).rjust(8, '0')}"
end

File.binwrite(ARGV[0], sav)

puts
