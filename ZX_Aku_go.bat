set diskfile=RelZX\Disk1.dsk

rem taskkill -f -im fuse.exe

copy Z:\ResZX\*.* Z:\BldZX

set infile=init_%DISKVER%.bin
set outfile=init
call :AddOneB_%DISKVER%

set infile=core_%DISKVER%.bin
set outfile=AKUCORE0
call :AddOneB_%DISKVER%

set infile=bootstrp_%DISKVER%.bin
set outfile=BOOTSTRP
call :AddOneB_%DISKVER%



set infile=SpecScreen.scr
set outfile=T38SC1Z1
call :AddOneZB_%DISKVER%

set infile=PlayerSprites.SPR
set outfile=T06SC1D0
call :AddOneB_%DISKVER%

set infile=Font.FNT
set outfile=T07SC1Z0
call :AddOneZB_%DISKVER%

set infile=Loading_Screen.bin
set outfile=T29SC1Z0
call :AddOneZB_%DISKVER%


set infile=Sfx.Bin
set outfile=T06SC8D0
call :AddOneB_%DISKVER%

rem set infile=Music.Bin
rem set outfile=T01SC8D1
rem call :AddOneB_%DISKVER%


rem ;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Title ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

set infile=Title.bin
set outfile=T08SC9D1
call :AddOneB_%DISKVER%

set infile=Level00.bin
set outfile=T08SC1Z1
call :AddOneZB_%DISKVER%




rem ;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Level 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

set infile=Level_Screen.bin
set outfile=T10SC8Z1
call :AddOneZB_%DISKVER%


set infile=GameMain.bin
set outfile=T10SC9D1
call :AddOneB_%DISKVER%

set infile=Level1B.SPR
set outfile=T10SC2D1
call :AddOneB_%DISKVER%

set infile=Level01.bin
set outfile=T10SC1Z1
call :AddOneZB_%DISKVER%

rem ;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Level 2 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


set infile=BossC000.bin
set outfile=T14SC9D1
call :AddOneB_%DISKVER%

set infile=Level2B-ZX.spr
set outfile=T14SC2D1
call :AddOneB_%DISKVER%


set infile=Level02.bin
set outfile=T14SC1Z1
call :AddOneZB_%DISKVER%


rem ;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Level 3 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


set infile=Level2_Screen.bin
set outfile=T20SC8Z1
call :AddOneZB_%DISKVER%


set infile=Level3B-ZX.spr
set outfile=T20SC2D1
call :AddOneB_%DISKVER%


set infile=Level03.bin
set outfile=T20SC1Z1
call :AddOneZB_%DISKVER%

rem ;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Level 4 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



set infile=Level4B-ZX.spr
set outfile=T24SC2D1
call :AddOneB_%DISKVER%


set infile=Level04.bin
set outfile=T24SC1Z1
call :AddOneZB_%DISKVER%



rem ;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Level 5 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
if NOT %DISKVER%==DSK goto NotDSK
set diskfile=RelZX\Disk2.dsk
:NotDSK

set infile=Level3_Screen.bin
set outfile=T10SC8Z2
call :AddOneZB_%DISKVER%


set infile=GameMain.bin
set outfile=T10SC9D2
call :AddOneB_%DISKVER%

set infile=Level5B-ZX.spr
set outfile=T10SC2D2
call :AddOneB_%DISKVER%

set infile=Level05.bin
set outfile=T10SC1Z2
call :AddOneZB_%DISKVER%


rem ;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Level 6 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

set infile=BossC000.bin
set outfile=T14SC9D2
call :AddOneB_%DISKVER%

set infile=Level6D-ZX.spr
set outfile=T14SC4D2
call :AddOneB_%DISKVER%


set infile=Level6C-ZX.spr
set outfile=T14SC3D2
call :AddOneB_%DISKVER%

set infile=Level6B-ZX.spr
set outfile=T14SC2D2
call :AddOneB_%DISKVER%

set infile=Level06.bin
set outfile=T14SC1Z2
call :AddOneZB_%DISKVER%

rem ;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Level 7 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

set infile=Level4_Screen.bin
set outfile=T20SC8Z2
call :AddOneZB_%DISKVER%


set infile=Level7B-ZX.spr
set outfile=T20SC2D2
call :AddOneB_%DISKVER%


set infile=Level07.bin
set outfile=T20SC1Z2
call :AddOneZB_%DISKVER%

rem ;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Level 8 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


set infile=Level8B-ZX.spr
set outfile=T25SC2D2
call :AddOneB_%DISKVER%


set infile=Level08.bin
set outfile=T25SC1Z2
call :AddOneZB_%DISKVER%

rem ;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Level 9 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

set infile=Level9B-ZX.spr
set outfile=T29SC2D2
call :AddOneB_%DISKVER%

set infile=Level09.bin
set outfile=T29SC1Z2
call :AddOneZB_%DISKVER%


rem ;;;;;;;;;;;;;;;;;;;;;;;;;;;;; EndIntro ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


set infile=SpeechB-ZX.spr
set outfile=T38SC2D2
call :AddOneB_%DISKVER%


set infile=Level250.bin
set outfile=T38SC1Z2
call :AddOneZB_%DISKVER%

rem ;;;;;;;;;;;;;;;;;;;;;;;;;;;;; EndOutro ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


set infile=SpeechB-ZX.spr
set outfile=T50SC2D2
call :AddOneB_%DISKVER%


set infile=Level251.bin
set outfile=T50SC1Z2
call :AddOneZB_%DISKVER%


rem ;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Intro ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



set infile=IntroC000.bin
set outfile=T56SC9D2
call :AddOneB_%DISKVER%


set infile=LEVEL252B-ZX.spr
set outfile=T56SC2D2
call :AddOneB_%DISKVER%


set infile=Level252.bin
set outfile=T56SC1Z2
call :AddOneZB_%DISKVER%

set infile=Level252-Screens1.bin
set outfile=T56SC3D2
call :AddOneB_%DISKVER%

set infile=Level252-Screens2.bin
set outfile=T56SC4D2
call :AddOneB_%DISKVER%




rem ;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Game Over ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
if NOT %DISKVER%==DSK goto NotDSKB
set diskfile=RelZX\Disk1.dsk
:NotDSKB


set infile=GameOver.Bin
set outfile=T34SC2Z1
call :AddOneZB_%DISKVER%


goto Launch_%DISKVER%


rem -----------------------------------------------------

:Launch_TAP
Utils\mktap -b "Loader" 10 <ResZX%Lang%\akuLoader.bas >BldZX%Lang%\Loader.tap
copy /B /Y BldZX%Lang%\loader.tap%AddedFiles% %tapefile%
Emu\Fuse\fuse.exe  --tape %tapefile% 
rem    --machine 48
exit

:AddOne_TAP
set OutFile=%infile:~0,8%

:AddOneB_TAP
copy BldZX%Lang%\%infile% BldZX%Lang%\%OutFile%.C
Utils\bintap BldZX%Lang%\%OutFile%.C BldZX%Lang%\%OutFile%.tap "%OutFile%C" 28672
set AddedFiles=%AddedFiles%+BldZX%Lang%\%OutFile%.tap
goto :eof


rem -----------------------------------------------------

:AddOneZ_TAP
set OutFile=%infile:~0,8%

:AddOneZB_TAP
Utils\lz48.exe -i BldZX%Lang%\%infile% -o BldZX%Lang%\%infile%.Z
copy BldZX%Lang%\%infile%.Z BldZX%Lang%\%OutFile%.C
Utils\bintap BldZX%Lang%\%OutFile%.C BldZX%Lang%\%OutFile%.tap "%OutFile%C" 28672
set AddedFiles=%AddedFiles%+BldZX%Lang%\%OutFile%.tap
goto :eof


rem -----------------------------------------------------


:Launch_TRD
copy fusetrd.cfg "%userprofile%\fuse.cfg"
Utils\trdtool.exe %trdfile% 
Emu\Fuse\fuse.exe  --machine 128 --beta128 --betadisk %trdfile% --snapshot Emu\akutrd.szx
exit



:AddOne_TRD
set OutFile=%infile:~0,8%

:AddOneB_TRD
copy BldZX%Lang%\%infile% BldZX%Lang%\%OutFile%.C
Utils\trdtool.exe ! %trdfile% BldZX%Lang%\%OutFile%.C
Utils\trdtool.exe + %trdfile% BldZX%Lang%\%OutFile%.C
goto :eof



rem -----------------------------------------------------




:AddOneZ_TRD
set OutFile=%infile:~0,8%

:AddOneZB_TRD
Utils\lz48.exe -i BldZX%Lang%\%infile% -o BldZX%Lang%\%infile%.Z
copy BldZX%Lang%\%infile%.Z BldZX%Lang%\%OutFile%.C
Utils\trdtool.exe ! %trdfile% BldZX%Lang%\%OutFile%.C
Utils\trdtool.exe + %trdfile% BldZX%Lang%\%OutFile%.C
goto :eof



rem -----------------------------------------------------

:Launch_DSK
Emu\Fuse\fuse.exe --machine plus3 --plus3disk %diskfile% --snapshot Emu\akudsk.szx
exit

rem -----------------------------------------------------

:AddOne_DSK
set OutFile=%infile:~0,8%

:AddOneB_DSK
Utils\PlusThreeHeader.exe BldZX%Lang%\%infile% BldZX%Lang%\%OutFile%.C
Utils\CPCDiskXP.exe -File BldZX%Lang%\%OutFile%.C -AddToExistingDsk %diskfile%
goto :eof


rem -----------------------------------------------------

:AddOneZ_DSK
set OutFile=%infile:~0,8%

:AddOneZB_DSK
Utils\lz48.exe -i BldZX%Lang%\%infile% -o BldZX%Lang%\%infile%.Z
Utils\PlusThreeHeader.exe BldZX%Lang%\%infile%.Z BldZX%Lang%\%OutFile%.C
Utils\CPCDiskXP.exe -File BldZX%Lang%\%OutFile%.C -AddToExistingDsk %diskfile%
goto :eof