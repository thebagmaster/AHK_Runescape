#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

CoordMode, Pixel
CoordMode, Mouse
IfWinNotExist, DebugView
	run dbgview.exe

f4::
	ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, nav.bmp
	MouseGetPos , mx, my
	outputdebug, % (mx-foundx) " " (my-foundy)
return