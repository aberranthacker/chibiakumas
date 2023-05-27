# The code is taken from
# https://github.com/nzeemin/ukncbtl-utils/blob/master/Sav2Cartridge/Sav2Cart.cpp
# One can write C in any laguage)

module Encoders
  module Rle
    extend self

    def call(src, debug: false)
      seq_block_offset = 0
      seq_block_size = 1
      var_block_offset = 0
      var_block_size = 1
      previous_byte  = src[0]
      coded_size_total = 0

      src = src.unpack('C*')
      buffer = []

      1.upto(src.length) do |current_offset|
        current_byte = if current_offset < src.length
                         src[current_offset]
                       else
                         previous_byte
                       end

        if ((current_offset == src.length) ||
            (current_byte != previous_byte && seq_block_size > 31) ||
            (current_byte != previous_byte && seq_block_size > 1 && previous_byte == 0) ||
            (current_byte != previous_byte && seq_block_size > 1 && previous_byte == 0xFF) ||
            (seq_block_size == 0x1FFF || var_block_size - seq_block_size == 0x1FFF))
          if var_block_offset < seq_block_offset
            # Special case at the end of input stream
            var_size =  if (current_offset == src.length && seq_block_size < 2)
                          var_block_size
                        else
                          var_block_size - seq_block_size
                        end

            coded_size = var_size + ((var_size < 256 / 8) ? 1 : 2)
            sprintf("RLE  at\t%06o\tVAR  %06o  %06o\t", var_block_offset + 512, var_size, coded_size) if debug
            coded_size_total += coded_size

            flag_byte = 0x40
            if var_size < 256 / 8
              sprintf("%02x ", (flag_byte | var_size)) if debug
              buffer << (flag_byte | var_size)
            else
              sprintf("%02x ", (0x80 | flag_byte | ((var_size & 0x1F00) >> 8))) if debug
              buffer << (0x80 | flag_byte | ((var_size & 0x1F00) >> 8))
              sprintf("%02x ", (var_size & 0xFF)) if debug
              buffer << (var_size & 0xFF)
            end

            var_block_offset.upto(var_size - 1) do |offset|
              puts src[offset] if debug
              buffer << src[offset]
            end

            puts if debug
          end

          if (var_block_offset < seq_block_offset && seq_block_size > 1) ||
              (var_block_offset == seq_block_offset && var_block_size == seq_block_size)
            coded_size = (seq_block_size < 256 / 8) ? 1 : 2
            coded_size += (previous_byte == 0 || previous_byte == 255) ? 0 : 1

            sprintf("RLE  at\t%06o\tSEQ  %06o  %06o\t%02x\n",
                    seq_block_offset + 512,
                    seq_block_size,
                    coded_size,
                    previous_byte
                   ) if debug

            coded_size_total += coded_size
            flag_byte = ((previous_byte == 0) ? 0 : ((previous_byte == 255) ? 0x60 : 0x20))
            if (seq_block_size < 256 / 8)
              buffer << (flag_byte | seq_block_size)
            else
              buffer << (0x80 | flag_byte | ((seq_block_size & 0x1F00) >> 8))
              buffer << (seq_block_size & 0xFF)
            end

            buffer << previous_byte unless previous_byte == 0 || previous_byte == 255
          end

          seq_block_offset = current_offset
          var_block_offset = current_offset
          seq_block_size = 1
          var_block_size = 1

          previous_byte = current_byte
          next
        end

        var_block_size += 1

        if current_byte == previous_byte
          seq_block_size += 1
        else
          seq_block_size = 1
          seq_block_offset = current_offset
        end

        previous_byte = current_byte;
      end # while

      puts "RLE input size #{src.length} bytes"
      puts "RLE output size #{coded_size_total} bytes #{coded_size_total * 100.0 / src.length}%"

      buffer
    end
  end
end

Encoders::Rle.call(File.binread('resources/ep1-intro-pics.SPR'), debug: true)
