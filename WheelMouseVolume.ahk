;;--- Head --- Informations --- AHK ---

;;	mouse volume control - over taskbar only - with sound
;;	THANKS wOxxOm https://autohotkey.com/board/topic/7977-volumouse-trick-mouse-volume-control-over-taskbar-only/
;;	Compatibility: Windows
;;	All files must be in same folder. Where you want.
;;	64 bit AHK version : 1.1.24.2 64 bit Unicode

;;--- Software options ---

	#SingleInstance Force
	#Persistent
	#NoEnv
	SetWorkingDir, %A_ScriptDir%

	SetEnv, title, MouseWheelVolume
	SetEnv, mode, Mouse volume control over taskbar.
	SetEnv, version, Version 2017-09-21-0844
	SetEnv, author, LostByteSoft

	;IniRead, sound, c:\windows\system.ini, drivers, sound
	;IfEqual, sound, ERROR, SetEnv, sound, 0
	;IfEqual, sound, ERROR, IniWrite, 0, c:\windows\system.ini, drivers, sound

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

	IniRead, sound, MouseWheelVolume.ini, options, sound
	IniRead, place, MouseWheelVolume.ini, options, place

;;--- Menu Tray options ---

	Menu, Tray, NoStandard
	Menu, tray, add, --= Mouse Wheel Volume =--, about1
	Menu, Tray, Icon, --= Mouse Wheel Volume =--, ico_wheel.ico
	Menu, tray, add, Show logo, GuiLogo
	Menu, tray, add, About - %author%, about3				; Creates a new menu item.
	Menu, Tray, Icon, About - %author%, ico_about.ico
	Menu, tray, add, %Version%, version					; About version
	Menu, Tray, Icon, %Version%, ico_about.ico
	Menu, tray, add,
	Menu, tray, add, Exit Mouse Volume, ExitApp				; ExitApp exit program
	Menu, Tray, Icon, Exit Mouse Volume, ico_shut.ico
	Menu, tray, add,
	Menu, tray, add, --= Options =--, about2
	Menu, Tray, Icon, --= Options =--, ico_options.ico
	Menu, tray, add,
	Menu, tray, add, Sound On/Off = %sound%, soundonoff 			; Sound on off
	Menu, Tray, Icon, Sound On/Off = %sound%, ico_Sound.ico
	Menu, tray, add, Taskbar or Screen = %place%, placeonoff 		; Sound on off
	Menu, Tray, Icon, Taskbar or Screen = %place%, ico_options.ico
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

placeonoff:
	IfEqual, place, 1, goto, disableplace
	IfEqual, place, 0, goto, enableplace
	msgbox, error_03 place error place=%place%
	Goto, Start

	enableplace:
	SetEnv, place, 1
	IniWrite, 1,MouseWheelVolume.ini, options, place
	TrayTip, %title%, Place enabled %place%, 2, 2
	Menu, Tray, Rename, Taskbar or Screen = 0, Taskbar or Screen = 1
	Goto, Start

	disableplace:
	SetEnv, place, 0
	IniWrite, 0, MouseWheelVolume.ini, options, place
	TrayTip, %title%, Place disabled %place%, 2, 2
	Menu, Tray, Rename, Taskbar or Screen = 1, Taskbar or Screen = 0
	Goto, Start

;;--- Quit (escape , esc) ---

ExitApp:
	ExitApp

;;--- Tray Bar (must be at end of file) ---

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

GuiLogo:
	Gui, Add, Picture, x25 y25 w400 h400 , ico_wheel.ico
	Gui, Show, w450 h450, %title% Logo
	Gui, Color, 000000
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