#!/bin/sh
AS=~/opt/binutils-pdp11/pdp11-dec-aout/bin/as
LD=~/opt/binutils-pdp11/pdp11-dec-aout/bin/ld

rm -f *.SAV
rm -f *.BIN

ruby build/preprocessor.rb -i bootstrap.s

echo "compiling..."
$AS core.s -o core.o
$AS bootstrap.s -o bootstrap.o

echo "linking..."
# --just-symbols= -R
# --print-map -M
# --strip-all -s
$LD core.o -o core.out -T linker_scripts/core.cmd -s
ruby build/aout2sav.rb core.out -b -o CORE.BIN
$LD -T linker_scripts/bootstrap.cmd -R core.o -s
chmod -x AKU.SAV

ruby build/add_CCB.rb AKU.SAV

echo "done :)"

# $AS ppu.s -a -o ppu.o
# $LD ppu.o -o ppu.out
# ruby build/aout2sav.rb ppu.out -b -o PPU.BIN

rm -f *.o
rm -f *.out
