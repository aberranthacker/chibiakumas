@echo --------------------------------------------------------------------------
@echo 	Keith's Z80 Dev Toolkit - Please see the Readme for instructions!
@echo --------------------------------------------------------------------------
@echo 			Start Enterprise via Disk Image V1.0
@echo. 			
@echo 		This tool loads your program into a disk image and starts
@echo 			The enterprise emulator with the disk image
@echo. 
@echo --------------------------------------------------------------------------
del RelENT\disk.img
rem copy RelENT\blank.img RelENT\disk.img
rem utils\BFI -t=3 -f=RelENT\disk.img BldEnt\
utils\BFI -t=4 -f=RelENT\disk.img BldEnt\
cd Emu\Ep128\
@echo off
if exist "%appdata%\.ep128emu\ep128cfg.dat" goto SetupDone
md "%appdata%\.ep128emu"
copy ep128cfg.dat "%appdata%\.ep128emu\"
copy gui_cfg.dat "%appdata%\.ep128emu\"

:SetupDone
taskkill -im ep128emu.exe  
@echo on
ep128emu.exe -no-opengl -cfg ..\Ep128-Disk.cfg -snapshot Disk.ep128s
utils\sleep 60