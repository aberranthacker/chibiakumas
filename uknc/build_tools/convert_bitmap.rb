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

require_relative 'reverse_tables'

cpc_bmp = File.binread('../ResCPC/Old/T38-SC1.D01').unpack('v*')
uknc_bmp = []

# take 1000 words, skip 24 words
cpc_bmp = cpc_bmp[   0, 1000] +
          cpc_bmp[1024, 1000] +
          cpc_bmp[2048, 1000] +
          cpc_bmp[3072, 1000] +
          cpc_bmp[4096, 1000] +
          cpc_bmp[5120, 1000] +
          cpc_bmp[6144, 1000] +
          cpc_bmp[7168, 1000]

cpc_bmp.each.with_index do |cpc_word, i|
  nibble1 = REVERSE_TABLE_4BIT[(cpc_word & 0x000F)]
  nibble2 = REVERSE_TABLE_4BIT[(cpc_word & 0x00F0) >> 4]
  nibble3 = REVERSE_TABLE_4BIT[(cpc_word & 0x0F00) >> 8]
  nibble4 = REVERSE_TABLE_4BIT[(cpc_word & 0xF000) >> 12]

  uknc_word = (nibble3 << 12 | nibble1 << 8 | nibble4 << 4 | nibble2)

  line_idx = i / 40 # 40 words per line
  word_idx_within_a_line = i % 40
  line = line_idx % 25
  row  = line_idx / 25
  uknc_line_idx = line * 8 + row
  uknc_word_idx = uknc_line_idx * 40 + word_idx_within_a_line

  uknc_bmp[uknc_word_idx] = uknc_word
end

File.binwrite('build/loading_screen.bin', uknc_bmp.pack('v*'))
