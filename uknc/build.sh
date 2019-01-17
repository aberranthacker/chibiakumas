#!/bin/sh
AS=~/opt/binutils-pdp11/pdp11-dec-aout/bin/as
LD=~/opt/binutils-pdp11/pdp11-dec-aout/bin/ld

rm -f *.lda
rm -f *.SAV

echo "compiling..."
$AS bootstrap.s -o bootstrap.o
$AS core.s -o core.o
echo "linking..."
$LD bootstrap.o -o aku.out
$LD core.o -o core.out

build/aout2sav.rb aku.out
build/aout2sav.rb core.out

rm -f *.o
rm -f *.out
