set trdfile=RelZX\Disk1.trd
set DISKVER=TRD
rem Utils\trdtool.exe # %trdfile% 

copy RelZX\empty.trd %trdfile%

rem sample settings file
rem Utils\trdtool.exe + %trdfile% BldZX\SETUPV02.C

ZX_Aku_go.bat
exit

