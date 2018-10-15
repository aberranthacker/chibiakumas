taskkill -f -im fuse.exe

set tapefile=RelZX\tape.tap

set infile=spectest.bin
call :AddOne

set infile=SpecScreen.scr.z
set outfile=T01SC1Z1
call :AddOneB


Utils\mktap -b "Loader" 10 <BldZX\Loader.bas >BldZX\Loader.tap



copy /B /Y BldZX\loader.tap%AddedFiles% %tapefile%

Emu\Fuse\fuse.exe  --tape %tapefile% 
exit

:AddOne
set OutFile=%infile:~0,8%

:AddOneB
copy BldZX\%infile% BldZX\%OutFile%.C
Utils\bintap BldZX\%OutFile%.C BldZX\%OutFile%.tap "%OutFile%C" 32768
set AddedFiles=%AddedFiles%+BldZX\%OutFile%.tap
goto :eof