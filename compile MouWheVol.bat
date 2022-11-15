@echo ----------------------------------------------------------
@echo Compile version 2021-06-23
@echo Update 2022-11-15
@echo ----------------------------------------------------------
@taskkill /im "MouseWheelVolume.exe"
@echo ----------------------------------------------------------
@PATH C:\Program Files\AutoHotkey\Compiler;C:\windows\system32
@if not exist "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe" goto notins
Ahk2Exe.exe /in "MouseWheelVolume.ahk" /out "MouseWheelVolume.exe" /icon "ProgramIcons\ico_volume.ico" /mpress "0"
@echo ----------------------------------------------------------
@goto exit

:notins
@echo Ahk is not installed.
@pause

:exit
pause
@exit