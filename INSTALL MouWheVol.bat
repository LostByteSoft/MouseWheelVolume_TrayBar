echo off
pushd "%~dp0
@echo -------------------------------------
echo LostByteSoft
echo Install version 2.2 2021-06-23
echo Architecture: x64
echo Compatibility : w7 w8 w8.1 w10 w11

echo PrintScreener
@echo ----------------------------------------------------------

taskkill /im "MouseWheelVolume.exe"

:copy
copy "MouseWheelVolume.exe" "C:\Program Files\"
copy "*.ico" "C:\Users\Administrator\AppData\Roaming%"

echo "You must close this command windows"
"C:\Program Files\MouseWheelVolume.exe"
pause
exit
