taskkill -f -im fuse.exe

set diskfile=RelZX\spectest2.dsk

set infile=SpecScreen.scr.z 
set outfile=T01SC1Z1B
call :AddOne



set infile=Music.Bin
set outfile=T01SC8D1
call :AddOneB


set infile=spectest.bin
call :AddOne

Emu\Fuse\fuse.exe --machine plus3 --plus3disk %diskfile% --snapshot Emu\dsk.szx




:AddOne
set OutFile=%infile:~0,8%.C

:AddOneB
Utils\PlusThreeHeader.exe BldZX\%infile% BldZX\%OutFile%
Utils\CPCDiskXP.exe -File BldZX\%OutFile% -AddToExistingDsk %diskfile%
goto :eof