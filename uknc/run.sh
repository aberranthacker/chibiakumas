#!/bin/sh

make -s
make -s

echo starting UKNCBTL
#wine cmd.exe /c "z:\home\random\opt\UKNCBTL\UKNCBTL.exe /boot" 2>/dev/null

# /boot — Автозапуск эмуляции, и затем в загрузочном меню выбоор загрузки с диска
# /bootN — Автозапуск эмуляции, и затем в загрузочном меню выбоор пункта N=1..7
# /autostart /autostarton — Включение автозапуска эмуляции
# /noautostart /autostartoff — Выключение автозапуска эмуляции
# /debug /debugon /debugger — Включение отладчика
# /debugoff /nodebug — Выключение отладчика
# /sound /soundon — Включение звука
# /nosound /soundoff — Выключение звука
# /fullscreen /fullscreenon — Полноэкранный режим
# /windowed /fullscreenoff — Оконный режим
# /diskN:filePath — Подключение образа дискеты, N=0..3
# /cartN:filePath — Подключение образа картриджа, N=1..2
# /hardN:filePath — Подключение образа жёсткого диска, N=1..2
~/opt/QtUkncBtl/QtUkncBtl -boot1 -disk0:dsk/chibiakumas.dsk

echo done
