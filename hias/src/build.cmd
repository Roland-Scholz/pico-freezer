@echo off
path=%PATH%;%CD%\..\atasm

cd freezer
atasm -r -olddbob.obj LDDBOB.M65
atasm -r -olddbol.obj LDDBOL.M65
atasm -r -f0 -obank1.rom BANK1.M65
atasm -r -f0 -obank2.rom BANK2.M65
atasm -r -f0 -obank3.rom BANK3.M65
copy /b bank3.rom+bank1.rom+bank2.rom freezer.rom

rem cd ..
rem atasm -r -osetbnk8.rom setbank.src
rem copy /b setbnk8.rom+oldos.rom setbank.rom
rem copy /b 16kblank.rom+8kblank.rom+freezer\freezer.rom+setbank.rom freezer.rom
rem copy /b freezer\freezer.rom+setbank.rom frz128.rom

rem atasm -oflash.com flash.src
rem atasm -opatch.com patch.src
pause
