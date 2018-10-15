cd BldTi
..\Utils\bin28xp.exe Test.bin --unprotected --nocomment
copy Test.8xp ..\RelTi
cd Z:\Emu\Wabbitemu\
copy Test.sav ..\Wabbitemuwabbitemu.sav
copy Test.sav Wabbitemuwabbitemu.sav
Z:\Emu\Wabbitemu\Wabbitemu.exe Test.sav  Z:\RelTi\Test.8xp
..\utils\sleep 60