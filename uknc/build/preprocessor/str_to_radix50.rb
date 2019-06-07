class StrToRadix50
  class << self
    POSITION_COEFFICIENTS = [03100, 00050, 00001]
    RADIX50_CHARS = ' ABCDEFGHIJKLMNOPQRSTUVWXYZ$._0123456789'.each_char.to_a # _ fills unused char position

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

      words_to_bytes_str(words)
    end

    def test
      str = 'DK SRAM  BIN'
      expected = %w[B8 1A 91 79 40 51 F6 0D].map { |h| "0x#{h}" }
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

    def words_to_bytes_str(words)
      words.pack('v*').each_char.map do |char|
        "0x#{char.ord.to_s(16).rjust(2, '0').upcase}"
      end
    end
  end
end
