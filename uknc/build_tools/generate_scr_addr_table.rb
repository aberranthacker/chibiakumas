x = 0x180

File.open('hex', 'w') do |f|
  200.times do |i|
    f.print '  .word ' if i % 8 == 0
    f.print "0x#{x.to_s(16).rjust(4,'0').upcase}"
    f.print (i+1) % 8 == 0 ? " # #{(i/8).to_s.rjust(2)}\n" : ', '
    x += 80
  end
end
