# Mode 1, 320×200, 4 colors (each byte of video memory represents 4 pixels):
# |     bit 7     |     bit 6     |     bit 5     |     bit 4     |
# |pixel 0 (bit 1)|pixel 1 (bit 1)|pixel 2 (bit 1)|pixel 3 (bit 1)|
#
# |     bit 3     |     bit 2     |     bit 1     |     bit 0     |
# |pixel 0 (bit 0)|pixel 1 (bit 0)|pixel 2 (bit 0)|pixel 3 (bit 0)|
#
#  0 - 0     25 - 1    50 - 2         175 - 7
#  1 - 8     26 - 9    51 - 10        176 - 15
#   ...        ...       ...     ...     ...
# 23 - 184   48 - 185  73 - 186       198 - 191
# 24 - 192   49 - 193  74 - 194       199 - 199

def reverse(int)
  int.to_s(2).reverse.to_i(2)
end

cpc_bmp = File.binread('../ResCPC/Old/T38-SC1.D01').unpack('v*')[64, 8000]
uknc_bmp = []
# d = []

cpc_bmp.each.with_index do |cpc_word, i|
  q1 = reverse(cpc_word & 0b1111)
  q2 = reverse(cpc_word & 0b1111_0000)
  q3 = reverse(cpc_word & 0b1111_0000_0000)
  q4 = reverse(cpc_word & 0b1111_0000_0000_0000)
  uknc_word = q1 | q3 << 4 | q2 << 8 | q4 << 12

  line_idx = i / 40 # 40 words per line
  word_idx_within_a_line = i % 40
  line = line_idx % 25
  row =  line_idx / 25
  uknc_line_idx = line * 8 + row
  uknc_word_idx = uknc_line_idx * 40 + word_idx_within_a_line

  uknc_bmp[uknc_word_idx] = uknc_word

  # d << {
  #   i: i,
  #   line_idx: line_idx,
  #   word_idx_within_a_line: word_idx_within_a_line,
  #   line: line,
  #   row: row,
  #   uknc_line_idx: uknc_line_idx,
  #   uknc_word_idx: uknc_word_idx
  # }
end

# d = d.uniq { |h| h[:line_idx] }

# File.open('foobar.txt', 'w') do |file|
# #word_idx_within_a_line: #{tuple[:word_idx_within_a_line].to_s.rjust(4, ' ')} \
#   d.each do |tuple|
#     file.puts "\
# i: #{tuple[:i].to_s.rjust(4, ' ')} \
# #{(((tuple[:line_idx] / 8) * 80) + ((tuple[:line_idx] % 8) * 2048)).to_s.rjust(5, ' ') } \
# line_idx: #{tuple[:line_idx].to_s.rjust(3, ' ')} \
# line: #{tuple[:line].to_s.rjust(3, ' ')} \
# row: #{tuple[:row].to_s.rjust(3, ' ')} \
# uknc_line_idx: #{tuple[:uknc_line_idx].to_s.rjust(3, ' ')} \
# uknc_word_idx: #{tuple[:uknc_word_idx].to_s.rjust(3, ' ')}"
#   end
# end

File.binwrite('build/LOADIN.SCR', uknc_bmp.pack('v*'))
