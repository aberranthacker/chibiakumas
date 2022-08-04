#!/bin/sh

make -s
make -s

echo starting UKNCBTL
#wine cmd.exe /c "z:\home\random\opt\UKNCBTL\UKNCBTL.exe /boot" 2>/dev/null
~/opt/QtUkncBtl/QtUkncBtl -boot1

echo done
