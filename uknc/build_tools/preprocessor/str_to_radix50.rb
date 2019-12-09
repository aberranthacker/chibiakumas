#
# Excerpt from "PDP-11 MACRO-11 Language Reference Manual":
#
# .RAD50
#
# The .RAD50 directive generates data in Radix-50 packed format. Radix-50 form
# allows three characters to be packed into 16 bits (one word); therefore, any
# 6-character symbol can be stored in two consecutive words.
#
# Each character is translated into its Radix-50 equivalent, as indicated in the
# following table:
# | Character   | Radix-50 Octal Equivalent |
# +-------------+---------------------------+
# | (space)     | 0
# | A-Z         | 01 - 032
# | $           | 033
# | .           | 034
# | (undefined) | 035
# | 0-9         | 036 - 047
#
# The Radix-50 equivalents for characters 1 through 3 (C1,C2,C3) are combined as
# follows:
# Radix-50 value == ((C1 * 050) + C2) * 050 + C3
# For example:
# Radix-50 value of "ABC" = ((1 * 050) + 2) * 050 + 3 = 03223
#
class StrToRadix50
  class << self
    POSITION_COEFFICIENTS = [050 * 050, 050, 1].freeze
                                                # _ fills unused char position
    RADIX50_CHARS = ' ABCDEFGHIJKLMNOPQRSTUVWXYZ$._0123456789'.chars.freeze

    def call(str)
      str = str.upcase
      words = []

      0.upto(str.length / 3 - 1).map { |i| i * 3 }.each do |triplet_start_index|
        word = 0
        0.upto(2) do |char_index|
          char = str[triplet_start_index + char_index]
          word += RADIX50_CHARS.index(char) * POSITION_COEFFICIENTS[char_index]
          words << word if char_index == 2
        end
      end

      words_to_str(words)
    end

    def test
      str = 'DK SRAM  BIN'
      expected = %w[1AB8 7991 5140 0DF6].map { |h| "0x#{h}" }
      actual = call(str)

      if actual == expected
        puts 'StrToRadix50 works as expected:'
        pp actual
      else
        pp actual
        puts 'does not matches:'
        pp expected
      end
    end

    private

    def words_to_str(words)
      words.map do |word|
        "0x#{word.to_s(16).rjust(4, '0').upcase}"
      end
    end
  end
end
