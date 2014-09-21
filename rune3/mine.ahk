#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

CoordMode, Pixel
CoordMode, Mouse
unsticks := 0

f1::
	Reload
return

f3::
	loop
	{
		loop
		{
			imgTravel("bearing.bmp",,-195,65,0)
			if(waitToMined())
				break
			imgTravel("bearing.bmp",,-140,10,0)
			if(waitToMined())
				break
		}
		moveU(8)
		moveR(6)
		moveU(54)
		moveL(39)
		moveD(8)
		openBank()
		depositAll()
		imgTravel("closebank.bmp")
		moveU(8)
		moveR(39)		;doesnt hit door perfect
		moveD(55)
		moveL(6)
		moveD(8)
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
		if(searchRange <25)
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
	
	FoundY-=10
	FoundX+=100
	Loop
	{
		PixelGetColor, ccolor, %FoundX%, %FoundY%
		sleep 200
		PixelGetColor, pcolor, %FoundX%, %FoundY%
		if(pcolor == ccolor)
			still+=1
		if(still > 8)
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
	send {left}
	send {right}
	send {left}
	send {right}
	imgTravel("nav.bmp",,-134,15,0)
	send {up down}
	sleep 3000
	send {up up}
}

openBank()
{
	imgTravel("bearing.bmp",,-195,50,0) ;open bank
	ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, closebank.bmp
	while(errorlevel)
	{
		ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, closebank.bmp
		sleep 100
	}
}

moveU(times=1)
{
	while times > 7
	{
		moveU8()
		times-=8
	}
	while times > 2
	{
		moveU3()
		times-=3
	}
	loop %times%
		imgTravel("nav.bmp",,-66,80)
}
moveU3()
{
	imgTravel("nav.bmp",,-66,72)
}
moveU8()
{
	imgTravel("nav.bmp",,-66,52)
}

moveD(times=1)
{
	while times > 7
	{
		moveD8()
		times-=8
	}
	while times > 2
	{
		moveD3()
		times-=3
	}
	loop %times%
		imgTravel("nav.bmp",,-66,88)
}
moveD3()
{
	imgTravel("nav.bmp",,-66,97)
}
moveD8()
{
	imgTravel("nav.bmp",,-66,118)
}

moveR(times=1)
{
	while times > 7
	{
		moveR8()
		times-=8
	}
	while times > 2
	{
		moveR3()
		times-=3
	}
	loop %times%
		imgTravel("nav.bmp",,-63,84)
}
moveR3()
{
	imgTravel("nav.bmp",,-56,84)
}
moveR8()
{
	imgTravel("nav.bmp",,-35,84)
}

moveL(times=1)
{
	while times > 7
	{
		moveL8()
		times-=8
	}
	while times > 2
	{
		moveL3()
		times-=3
	}
	loop %times%
		imgTravel("nav.bmp",,-70,84)
}
moveL3()
{
	imgTravel("nav.bmp",,-81,84)
}
moveL8()
{
	imgTravel("nav.bmp",,-101,84)
}