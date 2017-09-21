@taskkill /f /im "MouseWheelVolume.exe"
copy "*.ico" "C:\Program Files\"
copy "*.exe" "C:\Program Files\"
copy "*.ini" "C:\Program Files\"
copy "*.wav" "C:\Program Files\"
copy "*.lnk" "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\"
"C:\Program Files\MouseWheelVolume.exe"
@pause
@exit