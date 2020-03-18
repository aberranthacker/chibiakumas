#!/bin/sh

make

echo starting UKNCBTL
wine cmd.exe /c "z:\home\random\opt\UKNCBTL\UKNCBTL.exe /boot" 2>/dev/null

echo done
