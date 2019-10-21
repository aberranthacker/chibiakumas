# Mode 1, 320×200, 4 colors (each byte of video memory represents 4 pixels):
# |     bit 7     |     bit 6     |     bit 5     |     bit 4     |
# |pixel 0 (bit 1)|pixel 1 (bit 1)|pixel 2 (bit 1)|pixel 3 (bit 1)|
#
# |     bit 3     |     bit 2     |     bit 1     |     bit 0     |
# |pixel 0 (bit 0)|pixel 1 (bit 0)|pixel 2 (bit 0)|pixel 3 (bit 0)|
#
#  0 - 0     25 - 1     50 - 2        175 - 7
#  1 - 8     26 - 9     51 - 10       176 - 15
#   ...        ...        ...    ...     ...
# 23 - 184   48 - 185  73 - 186       198 - 191
# 24 - 192   49 - 193  74 - 194       199 - 199

cpc_bmp = File.binread('../ResCPC/Old/T38-SC1.D01').unpack('v*').first(8000)
uknc_bmp = []

cpc_bmp.each.with_index do |cpc_word, i|
  q1 = (cpc_word & 0b1111)
  q2 = (cpc_word & 0b1111_0000) >> 4
  q3 = (cpc_word & 0b1111_0000_0000) >> 8
  q4 = (cpc_word & 0b1111_0000_0000_0000) >> 12
  uknc_word = q1 | q3 << 4 | q2 << 8 | q4 << 12

  line_idx = i / 40 # 40 words per line
  word_idx_within_a_line = i % 40
  line = line_idx % 25
  row =  line_idx / 25
  uknc_line_idx = line * 8 + row
  uknc_word_idx = uknc_line_idx * 40 + word_idx_within_a_line

  uknc_bmp[uknc_word_idx] = uknc_word
end

File.binwrite('build/LOADIN.SCR', uknc_bmp.pack('v*'))
