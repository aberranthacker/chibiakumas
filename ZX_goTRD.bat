taskkill -f -im fuse.exe

set trdfile=RelZX\spectest.trd
rem create a blank file
utils\trdtool # %trdfile%

set infile=spectest.bin
call :AddOne

rem set infile=SpecScreen.scr.z
rem set outfile=T01SC1Z1
rem call :AddOneB

copy fusetrd.cfg "%userprofile%\fuse.cfg"
Emu\Fuse\fuse.exe  --machine 128 --beta128 --betadisk %trdfile% --snapshot Emu\trd.szx




:AddOne
set OutFile=%infile:~0,8%

:AddOneB
copy BldZX\%infile% BldZX\%OutFile%.C
Utils\trdtool.exe ! %trdfile% BldZX\%OutFile%.C
Utils\trdtool.exe + %trdfile% BldZX\%OutFile%.C
goto :eof