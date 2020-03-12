#!/bin/sh

make

cd build

echo building floppy disk image
cp -f RT11SJ54g.dsk aku.dsk
../build_tools/rt11dsk a aku.dsk AKU.SAV 1>/dev/null
../build_tools/rt11dsk a aku.dsk CORE.BIN 1>/dev/null
../build_tools/rt11dsk a aku.dsk PPU.BIN 1>/dev/null
../build_tools/rt11dsk a aku.dsk LVL00.BIN 1>/dev/null
../build_tools/rt11dsk a aku.dsk LOADIN.SCR 1>/dev/null

echo starting UKNCBTL
wine cmd.exe /c "z:\home\random\opt\UKNCBTL\UKNCBTL.exe /boot" 2>/dev/null

cd ..

echo done
