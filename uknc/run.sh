#!/bin/sh

make

cd build
cp -f RT11SJ54g.dsk aku.dsk
wine cmd.exe /c "z:\home\random\retrodev\aku\uknc\build\dsk.bat" 2>/dev/null
cd ..

