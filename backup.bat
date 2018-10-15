set bf=%date:/=%_%time::=%
Utils\7z a -r -x!emu -x!bak bak\bak_%bf%.7z *.* 
pause
