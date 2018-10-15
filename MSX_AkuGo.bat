@echo off

set DiskFile=RelMSX\Disk1%Lang%

copy \ResMSX%Lang%\*.* \BldMSX


set infile=LoadingScreen.rle
set outfile=T38-SC1.Z01
call :AddOneZB


set infile=PlayerSpritesMSX.MAP
set outfile=T06-SC1.D00
call :AddOneB

set infile=PlayerSpritesMSX.RLE
set outfile=T06-SC2.Z00
call :AddOneZB



set infile=PlayerIconsMSX.MAP
set outfile=T33-SC1.D00
call :AddOneB

set infile=PlayerIconsMSX.RLE
set outfile=T33-SC2.Z00
call :AddOneZB





set infile=Sfx.Bin
set outfile=T06-SC8.D00
call :AddOneB






set infile=Title.bin
set outfile=T08-SC9.Z01
call :AddOneZB


set infile=Loading.RLE
set outfile=T29-SC1.Z00
call :AddOneZB





set infile=Level0.RLE
set outfile=T09-SC1.Z01
call :AddOneZB

goto Language_%Lang%
rem ;;;;;;;;;;;;;;;;;;;;;;;;;;;; Japanese ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
:Language_J

	rem set infile=Font.RLE
	
	set infile=FontKana.RLE
	rem set infile=FontKata.RLE
	set outfile=T07-SC1.Z00
	call :AddOneZB


	set infile=BootStrp.V9K
	set outfile=BootStrp.V9K
	call :AddOneZB

	set infile=Core.V9K
	set outfile=Core.V9K
	call :AddOneZB

	set infile=BootStrp.AKU
	set outfile=BootStrp.AKU
	call :AddOneZB

	set infile=Core.AKU
	set outfile=Core.AKU
	call :AddOneZB


goto LanguageDone

rem ;;;;;;;;;;;;;;;;;;;;;;;;;;;; English ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
:Language_
	set infile=Font.RLE
	set outfile=T07-SC1.Z00
	call :AddOneZB

	set infile=BootStrp.V9K
	set outfile=BootStrp.V9K
	call :AddOneZB

	set infile=Core.V9K
	set outfile=Core.V9K
	call :AddOneZB

	set infile=BootStrp.AKU
	set outfile=BootStrp.AKU
	call :AddOneZB

	set infile=Core.AKU
	set outfile=Core.AKU
	call :AddOneZB

:LanguageDone
rem ;;;;;;;;;;;;;;;;;;;;;;;;;;;; LEVEL 0 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

set infile=T08-SC1.D01
set outfile=T08-SC1.Z01
call :AddOneZB


rem ;;;;;;;;;;;;;;;;;;;;;;;;;;;; LEVEL 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


set infile=T10-SC1.D01
set outfile=T10-SC1.Z01
call :AddOneZB


set infile=GameMain.bin
set outfile=T10-SC9.Z01
call :AddOneZB


set infile=LoadPic1_MSX.RLE
set outfile=T10-SC8.Z01
call :AddOneZB

set infile=Level1B.map
set outfile=T10-SC2.D01
call :AddOneB

set infile=Level1B.RLE
set outfile=T11-SC2.Z01
call :AddOneZB

set infile=Level1A.RLE
set outfile=T11-SC1.Z01
call :AddOneZB


set infile=Level01-TilesV9990.RLE
set outfile=T11-SC9.D01
call :AddOneB



rem ;;;;;;;;;;;;;;;;;;;;;;;;;;;; LEVEL 2 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



set infile=T14-SC1.D01
set outfile=T14-SC1.Z01
call :AddOneZB

set infile=BossC000.bin
set outfile=T14-SC9.Z01
call :AddOneZB

set infile=Level2B.map
set outfile=T14-SC2.D01
call :AddOneB

set infile=Level2B.RLE
set outfile=T15-SC2.Z01
call :AddOneZB

set infile=Level2A.RLE
set outfile=T15-SC1.Z01
call :AddOneZB


set infile=Level02-TilesV9990.RLE
set outfile=T15-SC9.D01
call :AddOneB




rem ;;;;;;;;;;;;;;;;;;;;;;;;;;;; LEVEL 3 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


set infile=LoadPic2_MSX.RLE
set outfile=T20-SC8.Z01
call :AddOneZB


set infile=T20-SC1.D01
set outfile=T20-SC1.Z01
call :AddOneZB


set infile=Level3B.map
set outfile=T20-SC2.D01
call :AddOneB

set infile=Level3B.RLE
set outfile=T21-SC2.Z01
call :AddOneZB

set infile=Level3A.RLE
set outfile=T21-SC1.Z01
call :AddOneZB


set infile=Level03-TilesV9990.RLE
set outfile=T21-SC9.D01
call :AddOneB



rem ;;;;;;;;;;;;;;;;;;;;;;;;;;;; LEVEL 4 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

set infile=Level4B.map
set outfile=T24-SC2.D01
call :AddOneB


set infile=T24-SC1.D01
set outfile=T24-SC1.Z01
call :AddOneZB



set infile=Level4B.RLE
set outfile=T25-SC2.Z01
call :AddOneZB

set infile=Level4A.RLE
set outfile=T25-SC1.Z01
call :AddOneZB


set infile=Level04-TilesV9990.RLE
set outfile=T25-SC9.D01
call :AddOneB




rem ;;;;;;;;;;;;;;;;;;;;;;;;;;;; LEVEL 5 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

set infile=GameMain.bin
set outfile=T10-SC9.Z02
call :AddOneZB


set infile=T10-SC1.D02
set outfile=T10-SC1.Z02
call :AddOneZB


set infile=LoadPic3_MSX.RLE
set outfile=T10-SC8.Z02
call :AddOneZB


set infile=Level5B.map
set outfile=T10-SC2.D02
call :AddOneB

set infile=Level5B.RLE
set outfile=T11-SC2.Z02
call :AddOneZB

set infile=Level5A.RLE
set outfile=T11-SC1.Z02
call :AddOneZB


set infile=Level05-TilesV9990.RLE
set outfile=T11-SC9.D02
call :AddOneB




rem ;;;;;;;;;;;;;;;;;;;;;;;;;;;; LEVEL 6 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

set infile=BossC000.bin
set outfile=T14-SC9.Z02
call :AddOneZB


set infile=T14-SC1.D02
set outfile=T14-SC1.Z02
call :AddOneZB

set infile=Level6B.map
set outfile=T14-SC2.D02
call :AddOneB

set infile=Level6C.map
set outfile=T14-SC3.D02
call :AddOneB

set infile=Level6D.map
set outfile=T14-SC4.D02
call :AddOneB

set infile=Level6B.RLE
set outfile=T15-SC2.Z02
call :AddOneZB

set infile=Level6C.RLE
set outfile=T15-SC3.Z02
call :AddOneZB

set infile=Level6D.RLE
set outfile=T15-SC4.Z02
call :AddOneZB

set infile=Level6A.RLE
set outfile=T15-SC1.Z02
call :AddOneZB

set infile=Level06-TilesV9990.RLE
set outfile=T15-SC9.D02
call :AddOneB




rem ;;;;;;;;;;;;;;;;;;;;;;;;;;;; LEVEL 7 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


set infile=LoadPic4_MSX.RLE
set outfile=T20-SC8.Z02
call :AddOneZB


set infile=Level7B.map
set outfile=T20-SC2.D02
call :AddOneB

set infile=Level7B.RLE
set outfile=T21-SC2.Z02
call :AddOneZB


set infile=T20-SC1.D02
set outfile=T20-SC1.Z02
call :AddOneZB

set infile=Level7A.RLE
set outfile=T21-SC1.Z02
call :AddOneZB

set infile=Level07-TilesV9990.RLE
set outfile=T21-SC9.D02
call :AddOneB


rem ;;;;;;;;;;;;;;;;;;;;;;;;;;;; LEVEL 8 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


set infile=T25-SC1.D02
set outfile=T25-SC1.Z02
call :AddOneZB

set infile=Level8B.map
set outfile=T25-SC2.D02
call :AddOneB

set infile=Level8B.RLE
set outfile=T26-SC2.Z02
call :AddOneZB


set infile=Level8A.RLE
set outfile=T26-SC1.Z02
call :AddOneZB

set infile=Level08-TilesV9990.RLE
set outfile=T26-SC9.D02
call :AddOneB





rem ;;;;;;;;;;;;;;;;;;;;;;;;;;;; LEVEL 9 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


set infile=T29-SC1.D02
set outfile=T29-SC1.Z02
call :AddOneZB

set infile=Level9B.map
set outfile=T29-SC2.D02
call :AddOneB

set infile=Level9B.RLE
set outfile=T30-SC2.Z02
call :AddOneZB


set infile=Level9A.RLE
set outfile=T30-SC1.Z02
call :AddOneZB

set infile=Level09-TilesV9990.RLE
set outfile=T30-SC9.D02
call :AddOneB





rem ;;;;;;;;;;;;;;;;;;;;;;;;;;;; LEVEL 252 -intro ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


set infile=T56-SC1.D02
set outfile=T56-SC1.Z02
call :AddOneZB

set infile=Level252B.map
set outfile=T56-SC2.D02
call :AddOneB

set infile=Level252B.RLE
set outfile=T57-SC2.Z02
call :AddOneZB


set infile=EP1_Intro1.map
set outfile=T56-SC3.D02
call :AddOneB

set infile=EP1_Intro1.RLE
set outfile=T57-SC3.D02
call :AddOneB




set infile=IntroC000.bin
set outfile=T56-SC9.Z02
call :AddOneZB


rem set infile=EP1_Intro2.map
rem rem set outfile=T56-SC4.D02
rem call :AddOneB

rem set infile=EP1_Intro2.RLE
rem set outfile=T57-SC4.D02
rem call :AddOneB



set infile=Level252A.RLE
set outfile=T57-SC1.Z02
call :AddOneZB



rem set infile=dummy.RLE
rem set outfile=T57-SC9.D02
rem call :AddOneB





rem ;;;;;;;;;;;;;;;;;;;;;;;;;;;; LEVEL End Intro ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


set infile=T38-SC1.D02
set outfile=T38-SC1.Z02
call :AddOneZB

set infile=SpeechB.map
set outfile=T38-SC2.D02
call :AddOneB
T38-SC1.D02

set infile=SpeechB.RLE
set outfile=T39-SC2.Z02
call :AddOneZB


set infile=SpeechA.RLE
set outfile=T39-SC1.Z02
call :AddOneZB

rem set infile=dummy.RLE
rem set outfile=T39-SC9.D02
rem call :AddOneB

rem ;;;;;;;;;;;;;;;;;;;;;;;;;;;; LEVEL End Outro ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


set infile=T50-SC1.D02
set outfile=T50-SC1.Z02
call :AddOneZB

set infile=SpeechB.map
set outfile=T50-SC2.D02
call :AddOneB

set infile=SpeechB.RLE
set outfile=T51-SC2.Z02
call :AddOneZB


set infile=SpeechA.RLE
set outfile=T51-SC1.Z02
call :AddOneZB



rem set infile=dummy.RLE
rem set outfile=T50-SC9.D02
rem call :AddOneB


rem set infile=Level251Screens.map
rem set outfile=T50-SC3.D02
rem call :AddOneB

set infile=Level251Screens.RLE
set outfile=T51-SC3.D02
call :AddOneB



rem ;;;;;;;;;;;;;;;;;;;;;;;;;;;;  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


set infile=GameOver.RLE
set outfile=T34-SC2.Z01
call :AddOneZB





utils\BFI -b=ResMSX\MsxBootDisk.bin -t=4 -f=RelMSX\disk1%Lang%.dsk Z:\RelMSX\Disk1%Lang%
cd Emu\openmsx\
openmsx.exe -machine Sony_HB-F1XDJ  -diska ..\..\RelMSX\disk1%Lang%.dsk -ext video9000



..\..\utils\sleep 60
exit

set infile=Sprite.SCR
set outfile=T02-SC2.D01
call :AddOneB


set infile=Sprite.MAP
set outfile=T02-SC1.D01
call :AddOneB


set infile=music.bin
set outfile=T01-SC8.D01
call :AddOneB

rem set infile=music.bin
rem set outfile=T01-SC8.D01
rem call :AddOneB




set infile=MsxFont.SCR
set outfile=MsxFont.BIN
call :AddOneB



pause


:AddOne
set OutFile=%infile:~0,8%

:AddOneB
utils\MsxHeader.exe BldMSX\%infile% BldMSX\%OutFile% 1000 
copy BldMSX\%OutFile% "%DiskFile%"
goto :eof


:AddOneZ
set OutFile=%infile:~0,8%

:AddOneZB
utils\lz48.exe -i BldMSX\%infile% -o BldMSX\%infile%.z
utils\MsxHeader.exe BldMSX\%infile%.z BldMSX\%OutFile% 1000 
copy BldMSX\%OutFile% "%DiskFile%"
goto :eof