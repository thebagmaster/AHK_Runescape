#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

CoordMode, Pixel
CoordMode, Mouse
unsticks := 0
winmove, RuneScape,,0,0,1870,1000

p::
	Pause
return

f3::
	loop
	{
		;~ loop
		;~ {
			;~ imgTravel("bearing.bmp",,-710,-40,0)
			;~ if(waitToMined())
				;~ break
			;~ imgTravel("bearing.bmp",,-640,-100,0)
			;~ if(waitToMined())
				;~ break
		;~ }

		;~ imgTravel("nav.bmp",,-45,18)
		;~ imgTravel("nav.bmp",,-71,13)
		;~ imgTravel("nav.bmp",,-87,15)
		;~ imgTravel("nav.bmp",,-136,83)
		;~ imgTravel("m6.bmp",,-22,37)
		;~ imgTravel("bearing.bmp",,-700,-60)
		;~ depositAll()
		;~ imgTravel("closebank.bmp")
		;~ imgTravel("nav.bmp",,-17,47)
		;~ imgTravel("nav.bmp",,0,85)
		;~ imgTravel("nav.bmp",,-56,147)
		;~ imgTravel("nav.bmp",,-56,147)
		;~ imgTravel("nav.bmp",,-56,147)
		imgTravel("m10.bmp",,-25,25)    ;minespot
	}
return

imgTravel(bmp,searchRange = 15, xoffset=0, yoffset=0,wait=1)
{
	loopCnt:=0
	ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight,% "*" searchRange " " bmp
	while(ErrorLevel)
	{
		sleep 100
		loopCnt+=1
		if(loopCnt > 40)
			unstick()
		if(searchRange <20)
			searchRange+=1
		ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight,% "*" searchRange " " bmp
	}
	mouseclick, l, FoundX+xoffset, FoundY+yoffset
	if wait
		waitToTravel()
}


waitToTravel()
{
	still := 0
	ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, bearing.bmp
	FoundX-=100
	Loop
	{
		PixelGetColor, ccolor, %FoundX%, %FoundY%
		sleep 500
		PixelGetColor, pcolor, %FoundX%, %FoundY%
		if(pcolor == ccolor)
			still+=1
		if(still > 5)
			return
	}
}

waitToMined()
{
	gatherInvPixels()
	ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, bearing.bmp
	sleep 1000
	global inventory
	loopCnt := 0
	Loop
	{
		loopCnt += 1
		incX := 40
		incY := 32
		X := 0
		Y := 0
			loop 7
			{
				loop 4
				{
					PixelGetColor, c, % FoundX+incX, % FoundY+incY
					;OutputDebug, % inventory[x,y] " vs " c "  " x "," y
					if loopCnt > 20
					{
						unstick()
						sleep 1000
						return false
					}
					if(abs(inventory[x,y] - c) > 10000)
					{
						outputdebug % x "," y
						if((x==2 and y==6)||(x==1 and y==6))
							return true
						else
							return false
					}
					else
						sleep 10
					x+=1
					incX += 42
				}
				y+=1
				x:=0
				incX := 40
				incY += 35
			}
	}
}

gatherInvPixels()
{
	ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, bearing.bmp
	global inventory := []
	incX := 40
	incY := 32
	X := 0
	Y := 0
	loop 7
	{
		loop 4
		{
			PixelGetColor, c, % FoundX+incX, % FoundY+incY
			inventory[x,y] := c
			x+=1
			incX += 42
		}
		y+=1
		x:=0
		incX := 40
		incY += 35
	}
}

depositAll()
{
	ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, bearing.bmp
	incX := 40
	incY := 32
	X := 0
	Y := 0
	loop 7
	{
		loop 4
		{
			if(incX>145 and incY>220)
				return					;skip pick
			else
				mouseclick , L, FoundX+incX, FoundY+incY, 2
			incX += 42
			sleep 100
		}
		x:=0
		incX := 40 
		incY += 35
	}
}

unstick()
{
	global unsticks += 1
	setkeydelay, 100,100
	if unsticks > 3
		imgTravel("bearing.bmp",,-700,-60,0)
	send {left}
	send {right}
	send {left}
	send {right}
	imgTravel("bearing.bmp",,-135,14,0)
	send {up down}
	sleep 3000
	send {up up}
}