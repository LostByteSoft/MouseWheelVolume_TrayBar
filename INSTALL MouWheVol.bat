pushd "%~dp0
@echo ----------------------------------------------------------
echo LostByteSoft
echo Install version: 2023-02-18
echo Architecture: x64
echo Compatibility : w7 w8 w8.1 w10 w11

echo Ico file location: C:\Users\YOURNAMEHERE\AppData\Roaming
echo Ico file location: %AppData%

echo MouseWheelVolume
@echo ----------------------------------------------------------
echo Kill process if exist.
taskkill /im "MouseWheelVolume.exe"
@echo ----------------------------------------------------------
:copy
copy "MouseWheelVolume.exe" "C:\Program Files\"
copy "MouseWheelVolume.lnk" "C:\Users\Public\Desktop\"

echo "You must close this command windows"
@echo ----------------------------------------------------------
"C:\Program Files\MouseWheelVolume.exe"
pause
exit
