;;--- Head --- Informations --- AHK ---

;;	mouse volume control - over taskbar only - with sound
;;	THANKS wOxxOm https://autohotkey.com/board/topic/7977-volumouse-trick-mouse-volume-control-over-taskbar-only/
;;	Compatibility: Windows
;;	All files must be in same folder. Where you want.
;;	64 bit AHK version : 1.1.24.2 64 bit Unicode

;;--- Software options ---

	SetWorkingDir, %A_ScriptDir%
	#SingleInstance Force
	#Persistent
	#NoEnv

	SetEnv, title, MouseWheelVolume
	SetEnv, mode, Mouse volume control over taskbar.
	SetEnv, version, Version 2017-10-11-1758
	SetEnv, author, LostByteSoft
	SetEnv, logoicon, ico_volume.ico

	FileInstall, MouseWheelVolume.ini, MouseWheelVolume.ini, 0
	FileInstall, ico_volume.ico, ico_volume.ico, 0
	FileInstall, ico_volume_r.ico, ico_volume_r.ico, 0
	FileInstall, snd_tick.wav, snd_tick.wav, 0
	FileInstall, ico_volume_2.ico, ico_volume_2.ico, 0
	FileInstall, ico_shut.ico, ico_shut.ico, 0
	FileInstall, ico_about.ico, ico_about.ico, 0
	FileInstall, ico_mute.ico, ico_mute.ico, 0
	FileInstall, ico_wheel.ico, ico_wheel.ico, 0
	FileInstall, ico_Sound.ico, ico_Sound.ico, 0
	FileInstall, ico_options.ico, ico_options.ico, 0
	FileInstall, ico_lock.ico,ico_lock.ico, 0

	IniRead, sound, MouseWheelVolume.ini, options, sound

;;--- Menu Tray options ---

	Menu, Tray, NoStandard
	Menu, tray, add, ---=== %title% ===---, about
	Menu, Tray, Icon, ---=== %title% ===---, %logoicon%
	Menu, tray, add, Show logo, GuiLogo
	Menu, tray, add, Secret MsgBox, secret					; Secret MsgBox, just show all options and variables of the program
	Menu, Tray, Icon, Secret MsgBox, ico_lock.ico
	Menu, tray, add, About && ReadMe, author
	Menu, Tray, Icon, About && ReadMe, ico_about.ico
	Menu, tray, add, Author %author%, about
	menu, tray, disable, Author %author%
	Menu, tray, add, %version%, about
	menu, tray, disable, %version%
	Menu, tray, add,
	Menu, tray, add, Exit, Close						; Close exit program
	Menu, Tray, Icon, Exit, ico_shut.ico
	;Menu, tray, add, Refresh FitScreen, doReload				; Reload the script. Usefull if you change something in configuration
	;Menu, Tray, Icon, Refresh FitScreen, ico_reboot.ico
	Menu, tray, add,
	Menu, tray, add, --= Options =--, about2
	Menu, Tray, Icon, --= Options =--, ico_options.ico
	Menu, tray, add, Sound On/Off = %sound%, soundonoff 			; Sound on off
	Menu, Tray, Icon, Sound On/Off = %sound%, ico_Sound.ico
	Menu, tray, add,
	Menu, tray, add, Win Mute / UnMute Sound, mute
	Menu, Tray, Icon, Win Mute / UnMute Sound, ico_mute.ico
	Menu, tray, add, Win Sound Mixer, SndVol				; Open windows sound mixer
	Menu, Tray, Icon, Win Sound Mixer, ico_volume_2.ico
	Menu, tray, add,
	Menu, Tray, Tip, Mouse Volume Control

;;--- Software start here ---

start:
	Menu, Tray, Icon, ico_volume.ico
	~WheelUp::mouseWheelVolume("+4")
	~WheelDown::mouseWheelVolume("-8")
	mouseWheelVolume(step)

	{
		mouseGetPos, mx, my, wnd
		wingetClass, cls, ahk_id %wnd%
		if cls=Shell_TrayWnd

		{
			Menu, Tray, Icon, ico_volume_r.ico
			SoundSet %step%
			soundSet 0, , mute
			soundGet vol
			ifInString,vol,.
			stringMid, vol,vol,1, % inStr(vol,".")-1
			IniRead, sound, MouseWheelVolume.ini, options, sound
			IfEqual, sound, 0, goto, SkipSound
			SoundPlay, snd_tick.wav
			SkipSound:
			tooltip, Volume : %vol%`%, % mx+25, % my-25, 19
			setTimer removeVolumeTip, 500
		}

		return
		removeVolumeTip:
		tooltip,,,,19
		settimer removeVolumeTip,OFF
		Menu, Tray, Icon, ico_volume.ico
		return
	}

	Return

mute:
	IfEqual, var, 1, goto, unmute
	Send {Volume_Mute}
	Menu, Tray, Icon, Win Mute / UnMute Sound, ico_volume_2.ico
	SetEnv, var, 1
	Goto, Start

	unmute:
	Send {Volume_Mute}
	Menu, Tray, Icon, Win Mute / UnMute Sound, ico_mute.ico
	SetEnv, var, 0
	Goto, Start

soundonoff:
	IfEqual, sound, 1, goto, disablesound
	IfEqual, sound, 0, goto, enablesound
	msgbox, error_02 sound error sound=%sound%
	Goto, Start

	enablesound:
	SetEnv, sound, 1
	SoundPlay, snd_tick.wav, wait
	IniWrite, 1,MouseWheelVolume.ini, options, sound
	TrayTip, %title%, Sound enabled %sound%, 2, 2
	Menu, Tray, Rename, Sound On/Off = 0, Sound On/Off = 1
	Goto, Start

	disablesound:
	SetEnv, sound, 0
	IniWrite, 0, MouseWheelVolume.ini, options, sound
	TrayTip, %title%, Sound disabled %sound%, 2, 2
	Menu, Tray, Rename, Sound On/Off = 1, Sound On/Off = 0
	Goto, Start

;;--- Quit (escape , esc) ---

Close:
	ExitApp

;Escape::		; For debug & testing
	ExitApp

doReload:
	Reload
	Return

;;--- Tray Bar (must be at end of file) ---

about:
about1:
about2:
about3:
	TrayTip, %title%, %mode%, 2, 1
	Return

version:
	TrayTip, %title%, %version% by %author%, 2, 2
	Return

SndVol:
	Run, SndVol.exe
	Return

author:
	MsgBox, 64, %title%, %title% %mode% %version% %author%. This software is usefull for modify volume with mouse wheel.`n`n`tGo to https://github.com/LostByteSoft
	Return

secret:
	MsgBox, 48, %title%,title=%title% mode=%mode% version=%version% author=%author%
	return

GuiLogo:
	Gui, Add, Picture, x25 y25 w400 h400 , %logoicon%
	Gui, Show, w450 h450, %title% Logo
	Gui, Color, 000000
	Sleep, 500
	return

;;--- End of script ---
;
;            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
;   Version 3.14159265358979323846264338327950288419716939937510582
;                          March 2017
;
; Everyone is permitted to copy and distribute verbatim or modified
; copies of this license document, and changing it is allowed as long
; as the name is changed.
;
;            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
;   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
;
;              You just DO WHAT THE FUCK YOU WANT TO.
;
;		     NO FUCKING WARRANTY AT ALL
;
;	As is customary and in compliance with current global and
;	interplanetary regulations, the author of these pages disclaims
;	all liability for the consequences of the advice given here,
;	in particular in the event of partial or total destruction of
;	the material, Loss of rights to the manufacturer's warranty,
;	electrocution, drowning, divorce, civil war, the effects of
;	radiation due to atomic fission, unexpected tax recalls or
;	    encounters with extraterrestrial beings 'elsewhere.
;
;              LostByteSoft no copyright or copyleft.
;
;	If you are unhappy with this software i do not care.
;
;;--- End of file ---