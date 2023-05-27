#!/usr/bin/ruby

require 'optparse'

options = Struct.new(:in_filename, :out_filename, :binary, :brief).new
OptionParser.new do |opts|
  opts.banner = "Usage: ruby aout_info.rb FILENAME"
  options.in_filename = opts.default_argv[0]

  opts.on("-o NAME", "--out-file=NAME", "filename to store resulting binary") do |v|
    options.out_filename = v
  end

  opts.on("-b", "--binary", "binary, pluck from entry point to end of a text segment") do
    options.binary = true
  end

  opts.on("-s", "--brief", "brief info") do
    options.brief = true
  end
end.parse!

exit unless options.in_filename

bin = File.binread(options.in_filename)

# The size of the header is not included in any of the other sizes.
header = bin[0,16].unpack('v*')
a_magic  = header[0] # magic number
a_text   = header[1] # size of text segment
a_data   = header[2] # size of initialized data
a_bss    = header[3] # size of uninitialized data
a_syms   = header[4] # size of symbol table
a_entry  = header[5] # entry point
a_unused = header[6] # not used
a_flag   = header[7] # relocation info stripped


magic_numbers = {
  0407 => 'normal',
  0410 => 'read-only text',
  0411 => 'separated I&D',
  0405 => 'overlay',
  0430 => 'auto-overlay (nonseparate)',
  0431 => 'auto-overlay (separate)'
}

unless options.brief
 puts "magic number:               #{a_magic.to_s(8)} (#{magic_numbers[a_magic]})"
 puts "size of text segment:       #{a_text}"
 puts "size of initialized data:   #{a_data}"
 puts "size of uninitialized data: #{a_bss}"
 puts "size of symbol table:       #{a_syms}"
 puts "entry point:                #{a_entry}"
 puts "not used:                   #{a_unused}"
 puts "relocation info stripped:   #{a_flag}"
 puts "size - entry:               #{a_text - a_entry}"
 puts "entry: #{a_entry} size: #{a_text - a_entry} ends: #{a_text}"
end

info = "#{a_entry},#{a_text - a_entry},#{a_text}"
File.write("#{options.out_filename}._", info)

# the start of the text segment in the file is 20(8)
text = if options.binary
         bin[020 + a_entry, a_text]
       else
         bin[020, a_text]
       end
# the start of the data segment is 20+St (the size of the text)
_data = bin[020 + a_text, a_data]
# the start of the relocation information is 20+St+Sd;
_bss  = bin[020 + a_text + a_data, a_bss]
# the start of the symbol table is 20+2(St+Sd) if the relocation
# information is present, 20+St+Sd if not.
syms_start = if a_bss > 0
               020 + 2 * (a_text + a_data)
             else
               020 + a_text + a_data
             end
_syms = bin[syms_start, a_syms]
# The symbol table consists of 6-word entries.  The first four
# words contain the ASCII name of the symbol, null-padded.
# The next word is a flag indicating the type of symbol.  The
# following values are possible:
#
#    00 undefined symbol
#    01 absolute symbol
#    02 text segment symbol
#    03 data segment symbol
#    37 file name symbol (produced by ld)
#    04 bss segment symbol
#    40 undefined external (.globl) symbol
#    41 absolute external symbol
#    42 text segment external symbol
#    43 data segment external symbol
#    44 bss segment external symbol

sav = text
# fill SAV image header --------------------------------------------------------
# highest_word_addr = text.length - 2
# sav[040, 2] = [a_entry].pack('v')           # program’s relative start address
# sav[042, 2] = [highest_word_addr].pack('v') # initial location of stack pointer
# sav[050, 2] = [highest_word_addr].pack('v') # address of the program’s highest word
#
# Locations 360–377 are the CCB and are are restricted for use by the system.
# The Linker stores the program memory usage bits in these eight words, which
# are called a bitmap.
# Each bit represents one 256-word block of memory and is set if the program
# occupies any part of that block of memory:
#     bit 7 of byte 360 corresponds to locations    0 through  777,
#     bit 6 of byte 360 corresponds to locations 1000 through 1777,
#     and so on.
# The monitor uses this information when it loads the program.
#-------------------------------------------------------------------------------
out_filename = if options.out_filename
                 options.out_filename
               else
                 "#{options.in_filename.split('.')[0].upcase}.SAV"
               end

File.binwrite(out_filename, sav)
