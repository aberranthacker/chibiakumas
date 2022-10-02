timer_ticks_occured = 0

256.times do |timer_current_tick|
  timer_ticks_occured = ((timer_current_tick + 1) ^ timer_current_tick) & 0xFF
  print "#{timer_current_tick.to_s(2).rjust(8, '0')} "
  print "#{timer_ticks_occured.to_s(2).rjust(8, '0')} "
  print "#{(timer_ticks_occured & 0x10).to_s(2).rjust(8, '0')} "
  puts
end
