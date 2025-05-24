#option_explicit

#constant PLAYER_ID 10
#constant ROCK_ID 20
#constant BASE_ID 30
#constant LANDED_ID 40

#constant BASE_COUNT 5
#constant PLAYER_COUNT 5

#constant SL_SETTING_FILE_NAME "shiplander_settings.txt"
#constant SL_SETTING_BEST_GAME_TIME "bestGameTime"
#constant SL_SETTING_NBR_LANDINGS "nbrLandings"
#constant SL_SETTING_PLAY_COUNT "playCount"

//-----------------------------------------------------
//
global sl as ShipLander

//-----------------------------------------------------
//
type ShipLander

	state as integer
	bgImg as integer
	bg as integer
	fgImg as integer
	fg as integer

	pw as float
	ph as float
	panel as integer
	panel2 as integer
	msgs as integer[10] // On panel.
	best as integer // Top of screen.
	games as integer // Top of screen.
	landings as integer // Top of screen.
	line as integer
	helpImg as integer
	helpBut as integer
	playImg as integer
	playBut as integer 
	nextImg as integer
	nextBut as integer 

	motherImg as integer
	mother as integer
	motherSpeed as float
	ascendSpeed as float
	motherY as float
	
	playerImg as integer
	player as integer
	dropSpeed as float
	thrustSpeed as float
	drop as integer // Flag to indicate player is dropping.
	playerX as float // Holds the last position of the player for dragging.

	rocksImg as integer
	rocks as integer[]

	baseImg as integer
	baseLefts as integer[]
	baseRights as integer[]

	explImg as integer
	expl as integer

	landeds as integer[] // Number of bases.

	playerFrames as integer[]
	playerScales as float[]
	thrustOffsets as float[]
	landOffsets as float[]
	playerFrameIdx as integer

	thrustImg as integer
	thrust as integer[2]
	thrustDy as float

	settings as KVPair[]
	gameTime as integer
	gameCount as integer

	resetBestTitle as integer
	resetBestBut as integer
	bestTimeY as float

	winImg as integer
	loseImg as integer
	win as integer

	helpIdx as integer
	helpIdxMax as integer
	agk2Img as integer
	agk2Icon as integer

	tapSound as integer
	releaseSound as integer
	hoverSound as integer
	landSound as integer
	explodeSound as integer
	hoverSoundInstance as integer

	lives as integer[] // objects for life icons.
	lifeCount as integer
	
endtype

//-----------------------------------------------------
// 
function slInit()

	sl.state = STATE_NONE
	sl.gameCount = 0
	
	local bx as float
	local by as float
	local base as integer
	local i as integer
	local y as float
	local gap as float
	local tmp as integer
	local s as float
	local sc as float
	local msg as integer
	local off as float
	local obj as integer
	
	coSetClearColor(co.black)
	//coSetClearColor(co.bluegrey[7])
	SetBorderColor(0, 0, 0)

	// End of common game code.

	sl.bgImg = LoadImage("gfx/space1024x768.png")
	sl.bg = createobject(sl.bgImg)

	if getwidth(sl.bg) < co.w or getheight(sl.bg) < co.h
		
		if co.w - getwidth(sl.bg) > co.h - getheight(sl.bg)
			s = co.h / getheight(sl.bg)
		else
			s = co.w / getwidth(sl.bg)
		endif
				
		SetScale(sl.bg, s)

	endif

	setpos(sl.bg, co.w2, co.h2)
	SetDepth(sl.bg, BACK_DEPTH)

	//sl.fgImg = LoadImage("gfx/multires_border.png")
	//sl.fg = createobject(sl.fgImg)
	//setpos(sl.fg, co.w2, co.h2)
	//SetDepth(sl.fg, FRONT_DEPTH)
	
	sl.games = CreateText("")
	SetTextFontImage(sl.games, co.font1)
	SetTextSize(sl.games, 50)
	coSetTextColor(sl.games, co.grey[4])
	SetTextAlignment(sl.games, 0)
	SetTextPosition(sl.games, co.iw0, co.ih0)
	SetTextDepth(sl.games, FRONT_DEPTH)

	sl.best = CreateText("")
	SetTextFontImage(sl.best, co.font1)
	SetTextSize(sl.best, 50)
	coSetTextColor(sl.best, co.grey[4])
	SetTextAlignment(sl.best, 2)
	SetTextPosition(sl.best, co.iw4, co.ih0)
	SetTextDepth(sl.best, FRONT_DEPTH)

	sl.landings = CreateText("")
	SetTextFontImage(sl.landings, co.font1)
	SetTextSize(sl.landings, 50)
	coSetTextColor(sl.landings, co.grey[4])
	SetTextAlignment(sl.landings, 1)
	SetTextPosition(sl.landings, co.iw2, co.ih0)
	SetTextDepth(sl.landings, FRONT_DEPTH)

	sl.line = Createobject(co.pix)
	SetScaleX(sl.line, co.iw)
	setscaley(sl.line, 2)
	Setpos(sl.line, co.w / 2, co.ih0 + 50)
	coSetSpriteColor(getsprite(sl.line), co.grey[1])
	SetDepth(sl.line, FRONT_DEPTH)

	sl.motherImg = LoadImage("gfx/mothership.png")
	sl.mother = createobject(sl.motherImg)
	SetScale(sl.mother, 0.25)
	SetDepth(sl.mother, PLAYER_DEPTH + 2)

	for i = 0 to 2
		
		obj = createobject(sl.motherImg)
		SetScale(obj, 0.05)
		setpos(obj, co.iw0 + getwidth(obj) / 2, getposy(sl.line) + 8 + getheight(obj) / 2 + i * getheight(obj))
		SetDepth(obj, PLAYER_DEPTH + 2)
		setvisible(obj, false)
		sl.lives.insert(obj)

	next

	sl.motherSpeed = 2	
	sl.ascendSpeed = 4
		
	sl.playerImg = LoadImage("gfx/Fighters2.png")
	sl.player = CreateObject(sl.playerImg)
	setid(sl.player, PLAYER_ID)
	SetSpriteShape(getsprite(sl.player), 3)
	SetDepth(sl.player, PLAYER_DEPTH)
	SetColGroup(sl.player, PLAYER_ID)
	SetColWith(sl.player, ROCK_ID, true)
	SetColWith(sl.player, BASE_ID, true)
	SetColWith(sl.player, LANDED_ID, true)

	sl.motherY = GetHeight(sl.mother) / 2 + getposy(sl.line) + 20
	
	sl.dropSpeed = 1
	sl.thrustSpeed = 0.2
	
	sl.rocksImg = loadimage("gfx/AGK_Asteroids1.png")
	sl.baseImg = loadimage("gfx/PlatformFloors2.png")
	sl.explImg = loadimage("gfx/Explosion1.png")

	sl.expl = CreateSprite(sl.explImg)
	SetSpriteAnimation(sl.expl, 64, 64, 7)
	SetSpriteScale(sl.expl, 2, 2)
	SetSpriteFrame(sl.expl, 7)
	//SetSpriteVisible(sl.expl, false)

	sl.thrustImg = loadimage("gfx/thrust.png")
	sl.thrust[0] = createobject(sl.thrustImg)
	SetDepth(sl.thrust[0], THING_DEPTH - 2)
	sl.thrust[1] = createobject(sl.thrustImg)
	SetDepth(sl.thrust[1], THING_DEPTH - 2)

	sl.playerFrames = [9, 3, 7, 5, 2]
	sl.playerScales = [0.6, 0.7, 0.8, 0.9, 1.0]
	sl.thrustOffsets = [8.0, 6.0, 12.0, 6.0, 2.0]
	sl.landOffsets = [6.0, 0.0, 2.0, -10.0, -20.0]
	
	sl.winImg = loadimage("gfx/Check.png")
	sl.loseImg = loadimage("gfx/Cross.png")
	sl.win = CreateSprite(sl.winImg)
	SetSpriteDepth(sl.win, THING_DEPTH)
	SetSpriteScaleByOffset(sl.win, 1.5, 1.5)
	SetSpritePositionByOffset(sl.win, co.w2, sl.motherY + 20)

	sl.helpImg = LoadImage("gfx/help.png")
	sl.helpBut = CreateObject(sl.helpImg)
	SetPos(sl.helpBut, co.iw0 + getwidth(sl.helpBut) / 2, getposy(sl.line) + getheight(sl.helpBut) / 2)
	coSetSpriteColor(getsprite(sl.helpBut), co.white)
	SetSpriteDepth(getsprite(sl.helpBut), GUI_VALUE_DEPTH)
	setscale(sl.helpBut, 0.75)

	sl.playImg = LoadImage("gfx/play.png")
	sl.playBut = CreateObject(sl.playImg)
	SetPos(sl.playBut, co.iw4 - getwidth(sl.playBut) / 2, getposy(sl.line) + getheight(sl.playBut) / 2)
	coSetSpriteColor(getsprite(sl.playBut), co.white)
	SetSpriteDepth(getsprite(sl.playBut), GUI_VALUE_DEPTH)

	// Made-With-AGK-128px
	sl.agk2Img = LoadImage("gfx/Made-With-AGK-250px.png")
	sl.agk2Icon = CreateObject(sl.agk2Img)
	SetPos(sl.agk2Icon, co.w2, co.h2 + 48)
	SetSpriteDepth(getsprite(sl.agk2Icon), GUI_VALUE_DEPTH)
	
	sl.pw = co.iw - 100
	sl.ph = co.ih - 400
	off = 30
	
	sl.panel = Createobject(co.pix)
	SetScaleX(sl.panel, sl.pw)
	setscaley(sl.panel, sl.ph)
	Setpos(sl.panel, co.w2, co.h2 + off)
	coSetSpriteColor(getsprite(sl.panel), co.grey[4])
	SetDepth(sl.panel, GUI_BACK_DEPTH)

	sl.panel2 = Createobject(co.pix)
	SetScaleX(sl.panel2, sl.pw - 20)
	setscaley(sl.panel2, sl.ph - 20)
	Setpos(sl.panel2, co.w2, co.h2 + off)
	coSetSpriteColor(getsprite(sl.panel2), co.grey[7])
	SetDepth(sl.panel2, GUI_CTRL_DEPTH)

	gap = 45
	y = co.h2 - sl.ph / 2 + 30 + off // co.h - 180

	msg = slCreateMsg("Ship Lander", y, co.white)
	SetTextFontImage(msg, co.font2)
	SetTextSize(msg, 80)
	sl.msgs[0] = msg
	y = y + gap + gap
	sl.msgs[1] = slCreateMsg("", y, co.grey[4])
	y = y + gap
	sl.msgs[2] = slCreateMsg("", y, co.grey[4])
	y = y + gap
	sl.msgs[3] = slCreateMsg("", y, co.grey[4])
	y = y + gap	
	sl.msgs[4] = slCreateMsg("", y, co.grey[4])
	y = y + gap	
	sl.msgs[5] = slCreateMsg("", y, co.grey[4])
	y = y + gap	
	sl.msgs[6] = slCreateMsg("", y, co.grey[4])
	y = y + gap	+ gap / 4 * 3
	sl.msgs[7] = slCreateMsg("", y, co.grey[2])
	y = y + gap	+ gap / 4 * 3

	sl.nextImg = LoadImage("gfx/next.png")
	sl.nextBut = CreateObject(sl.nextImg)
	setangle(sl.nextBut, 90)
	SetPos(sl.nextBut, co.w2, y)
	coSetSpriteColor(getsprite(sl.nextBut), co.white)
	SetSpriteDepth(getsprite(sl.nextBut), GUI_VALUE_DEPTH)

	//bx = 80
	by = 0

	// Create 5 bases.
	for i = 0 to BASE_COUNT - 1

		//sl.landeds[i] = 0
		
		base = CreateObject(sl.baseImg)		
		setid(base, BASE_ID)
		SetSpriteAnimation(GetSprite(base), 64, 63, 16)
		SetSpriteFrame(getsprite(base), 1)
		SetSpriteShape(getsprite(base), 3)
		SetScale(base, 0.75)

		if i = 0
			
			bx = co.w2 - (getwidth(base) * 2.5) * 2
			by = co.ih4 - getheight(base)

		endif

		setpos(base, bx - GetWidth(base) / 2, by)
		SetDepth(base, THING_DEPTH + 2)
		SetColGroup(base, BASE_ID)
		sl.baseLefts.insert(base)

		base = CreateObject(sl.baseImg)
		setid(base, BASE_ID)
		SetSpriteAnimation(GetSprite(base), 64, 63, 16)
		SetSpriteFrame(getsprite(base), 3)
		SetSpriteShape(getsprite(base), 3)
		SetScale(base, 0.75)
		setpos(base, bx + getwidth(base) / 2, by)
		SetDepth(base, THING_DEPTH + 2)
		SetColGroup(base, BASE_ID)
		sl.baseRights.insert(base)

		bx = bx + (getwidth(base) * 2.5)
		
	next

	sl.tapSound = slLoadSound("sounds/tap.wav")
	sl.releaseSound = slLoadSound("sounds/release1.wav")
	sl.hoverSound = slLoadSound("sounds/hover1.wav")
	sl.landSound = slLoadSound("sounds/land3.wav")
	sl.explodeSound = slLoadSound("sounds/explode1.wav")
	sl.hoverSoundInstance = 0
	
	sl.drop = false
	sl.helpIdx = 0
	sl.helpIdxMax = 1
	sl.lifeCount = 0

	coLoadSettings(SL_SETTING_FILE_NAME, sl.settings)
	//sl.bestTime = val(coGetSetting(sl.settings, SL_SETTING_BEST_GAME_TIME, "0"))

	slTitle()

	coDisplayAdvertBanner()
	
endfunction

//-----------------------------------------------------
// 
function slTitle()

	// Prep for first view.
	sl.playerFrameIdx = 0
	sl.lifeCount = 3
	slNextPlayer(false)
	slThrust(false)
	SetSpriteVisible(sl.win, false)

	slShowHelp(true, false)
	slShowScores(true, true)

endfunction

//-----------------------------------------------------
// 
function slCreateMsg(s as string, y as float, col as integer)

	local msg as integer
	
	msg = CreateText(s)
	SetTextFontImage(msg, co.font1)
	SetTextSize(msg, 50)
	coSetTextColor(msg, col)
	SetTextAlignment(msg, 1)
	SetTextPosition(msg, co.w2, y)
	SetTextDepth(msg, GUI_VALUE_DEPTH)
	SetTextVisible(msg, false)

endfunction msg

//-----------------------------------------------------
// 
function slDestroy()

	sl.state = STATE_NONE

	local i as integer
	
	// Clear game.
	slDelete()

	// Clear fantom objects.
	RemoveObject(sl.mother)
	RemoveObject(sl.player)
	RemoveObject(sl.thrust[0])
	RemoveObject(sl.thrust[1])

	for i = 0 to sl.baseLefts.length
		
		RemoveObject(sl.baseLefts[i])
		RemoveObject(sl.baseRights[i])

	next

	sl.baseLefts.length = -1
	sl.baseRights.length = -1
	
	DeleteSprite(sl.expl)
	
	deleteimage(sl.rocksImg)
	deleteimage(sl.baseImg)
	deleteimage(sl.explImg)
	deleteimage(sl.playerImg)
	deleteimage(sl.motherImg)
	DeleteImage(sl.thrustImg)

	sl.playerScales.length = -1
	sl.playerFrames.length = -1

	for i = 0 to sl.msgs.length
		DeleteText(sl.msgs[i])
	next

	sl.msgs.length = -1

	removeobject(sl.resetBestBut)
	deletetext(sl.resetBestTitle)

	deletesprite(sl.win)
	deleteimage(sl.winImg)
	deleteimage(sl.loseImg)

	RemoveObject(sl.games)
	RemoveObject(sl.best)
	RemoveObject(sl.landings)
	RemoveObject(sl.line)

	RemoveObject(sl.helpBut)
	deleteimage(sl.helpImg)
	RemoveObject(sl.nextBut)
	deleteimage(sl.nextImg)
	RemoveObject(sl.playBut)
	deleteimage(sl.playImg)
	removeobject(sl.panel)
	removeobject(sl.panel2)

	removeobject(sl.fg)
	deleteimage(sl.fgImg)

	removeobject(sl.bg)
	deleteimage(sl.bgImg)

	for i = 0 to 2
		deleteobject(sl.lives[i])
	next
	
endfunction

//-----------------------------------------------------
// 
function slCreate()
	
	sl.state = STATE_PLAY
	inc sl.gameCount
	
	local rock as integer
	local x as float
	local y as float
	local dy as float
	local i as integer
	local j as integer
	local count as integer
	local ang as float
	local speed as float
	local spin as float
	local dir as integer
	local tmp as string
	local playCount as integer
	local speeds as integer[]
	local idx as integer

	if sl.lifeCount = 0
		sl.playerFrameIdx = 0
	endif
	
	slNextPlayer(true)

	y = GetPosY(sl.mother) + GetHeight(sl.mother) / 2 + 120
	dy = 100
	dir = slRandomDir()
	ang = dir * 90
	speeds = [5, 10, 15, 20, 25]

	for i = 1 to 5

		count = random(1, 5)
		//x = random(96 / 2, co.iw1) // Starting rock.
		x = 0 + random(0, co.w / 5) // Starting rock.

		//speed = Random(5, 20) / 10.0
		idx = random(0, 4)

		while speeds[idx] = 0
			idx = random(0, 4)
		endwhile
		
		speed = speeds[idx] / 10.0
		speeds[idx] = 0
		
		//for j = 1 to count
		repeat

			// Create a rock.
			spin = ((Random(2, 5)) / 10.0) * dir
			rock = CreateObject(sl.rocksImg)
			SetID(rock, ROCK_ID)
			SetSpriteAnimation(GetSprite(rock), 128, 128, 16)
			SetSpriteFrame(getsprite(rock), random(1, 14))
			SetScale(rock, random(50, 70) / 100.0)
			SetSpriteShape(getsprite(rock), 3)
			setspeed(rock, speed, ang)			
			SetPos(rock, x, y)
			setspin(rock, spin)			
			SetColGroup(rock, ROCK_ID)
			SetDepth(rock, THING_DEPTH)			
			sl.rocks.insert(rock)

			// Change gaps to be small, or at least as wide as the player.
			// Ensure we don't go off the screen.
			
			//x = x + GetWidth(rock) + (random(1, 2) * 96)
			//x = x + GetWidth(rock) / 2 + random(1.0, 2.0) * 96
			x = x + GetWidth(rock) * 2 + random(0, co.w / 5)

		//next
		until x > co.w // co.iw4

		y = y + dy
		dir = -dir
		ang = dir * 90
		
	next

	if sl.lifeCount = 0
		
		sl.landeds = [0, 0, 0, 0, 0]

		SetSpriteVisible(sl.win, false)
		slThrust(false)

		tmp = coGetSetting(sl.settings, SL_SETTING_PLAY_COUNT, "0")

		if tmp = ""
			playCount = 0
		else
			playCount = val(tmp)
		endif

		inc playCount
		
		coSetSetting(sl.settings, SL_SETTING_PLAY_COUNT, str(playCount))
		coSaveSettings(SL_SETTING_FILE_NAME, sl.settings)

	endif

	if sl.lifeCount = 0
		sl.lifeCount = 3
	endif
	
	slShowHelp(false, false)
	slShowScores(true, true)
	slShowButs(false)

	if sl.lifeCount = 0		
		sl.gameTime = GetMilliseconds()
	endif

endfunction

//-----------------------------------------------------
// 
function slDelete()

	sl.state = STATE_NONE

	local i as integer
	
	for i = 0 to sl.rocks.length
		RemoveObject(sl.rocks[i])
	next

	sl.rocks.length = -1

	if sl.lifeCount = 0
		
		for i = 0 to sl.landeds.length

			if sl.landeds[i]					
				RemoveObject(sl.landeds[i])
			endif
			
		next

		sl.landeds.length = -1

	endif
	
endfunction

//-----------------------------------------------------
// Load a sound.
//
function slLoadSound(sound as string)

	local ret as integer

	ret = LoadSound(sound)
	//sl.sounds.insert(ret)
	
endfunction ret

//-----------------------------------------------------
// forReal is to allow the title screen to display mother and player, but no movement.
//
function slNextPlayer(forReal as integer)

	local r as integer

	r = slRandomDir() * 90
	
	//SetPos(sl.mother, co.w2, GetHeight(sl.mother) / 2 + getposy(ma.line) + 20)
	SetPos(sl.mother, co.w2, sl.motherY)
	
	if forReal
		setspeed(sl.mother, sl.motherSpeed, r)
	else
		setspeed(sl.mother, 0, 0)
	endif

	SetSpriteAnimation(GetSprite(sl.player), 96, 96, 10)
	SetSpriteFrame(GetSprite(sl.player), sl.playerFrames[sl.playerFrameIdx])
	setscale(sl.player, sl.playerScales[sl.playerFrameIdx])
	//setpos(sl.player, co.w2, getposy(sl.mother) + 30)
	//setpos(sl.player, co.w2, getposy(sl.mother) + 50)
	setpos(sl.player, co.w2, getposy(sl.mother) + 20 + getheight(sl.player) / 2)
	
	if forReal
		setspeed(sl.player, sl.motherSpeed, r)
	else
		setspeed(sl.player, 0, 0)
	endif
	
	SetVisible(sl.player, true)

	sl.drop = false

endfunction

//-----------------------------------------------------
// 
function slLoser()

	sl.drop = false
	sl.state = STATE_NONE // STATE_LOST

	slStopAll()

	dec sl.lifeCount

	if sl.lifeCount = 0

		SetSpriteImage(sl.win, sl.loseImg)
		coSetSpriteColor(sl.win, co.red[4])
		SetSpriteVisible(sl.win, true)	
		slShowButs(true)
			
	else
		
		slDelete()
		slCreate()
		
	endif

endfunction

//-----------------------------------------------------
//
function slWinner()

	sl.state = STATE_NONE // STATE_WON

	local checkTime as integer
	local tmp as string
	local bestTime as integer

	checkTime = GetMilliseconds() - sl.gameTime
	tmp = coGetSetting(sl.settings, SL_SETTING_BEST_GAME_TIME, "")
	
	if tmp = ""
		
		coSetSetting(sl.settings, SL_SETTING_BEST_GAME_TIME, str(checkTime))
		
	else

		bestTime = val(tmp)
		
		if checkTime < bestTime
			coSetSetting(sl.settings, SL_SETTING_BEST_GAME_TIME, str(checkTime))
		endif

	endif
				
	coSaveSettings(SL_SETTING_FILE_NAME, sl.settings)
	slShowScores(true, true)
	slShowHelp(false, false)
	slShowButs(true)

	SetVisible(sl.player, false)
	sl.drop = false
	slStopAll()

endfunction

//-----------------------------------------------------
// 
function slRandomDir()

	local r as integer

	r = random(0, 1)

	if r = 0 then r = -1
	
endfunction r

//-----------------------------------------------------
// 
function slUpdate()

	local i as integer
	local key as string
	local dx as float
	local dy as float
	local spr as integer
	local nx as float

	if sl.state = STATE_NONE

		if in.ptrPressed

			if sl.gameCount > 0 and GetFullscreenAdvertLoadedAdMob()
				
				ShowFullscreenAdvertAdMob()
		
			elseif coGetSpriteHitTest3(getsprite(sl.playBut), in.ptrX, in.ptrY, 20, 20, 20, 10)

				slPlaySound(sl.tapSound, false)
				slDelete()
				slCreate()

			elseif coGetSpriteHitTest3(getsprite(sl.helpBut), in.ptrX, in.ptrY, 20, 20, 20, 10)

				slPlaySound(sl.tapSound, false)
				slShowHelp(true, false)
				
			elseif coGetSpriteHitTest3(getsprite(sl.nextBut), in.ptrX, in.ptrY, 20, 20, 20, 20)

				slPlaySound(sl.tapSound, false)
				slShowHelp(true, true)
				
			endif

		endif
		
	elseif sl.state = STATE_PLAY

		if in.ptrPressed
				
			sl.playerX = in.ptrX
			
			if not sl.drop

				slPlaySound(sl.releaseSound, false)
				sl.drop = true
				SetTimer(sl.player, 10)
				SetSpeed(sl.player, sl.dropSpeed, 180)
				setspeed(sl.mother, sl.ascendSpeed, 0)
							
			endif

		elseif in.ptrDown

			if sl.drop
				
				slPlaySound(sl.hoverSound, true)
				SetSpeed(sl.player, sl.thrustSpeed, 180)
				dx = (in.ptrX - sl.playerX) / 2
				sl.playerX = in.ptrX
				nx = getposx(sl.player) + dx
				
				if nx < co.iw0 + getwidth(sl.player) / 2
					nx = co.iw0 + getwidth(sl.player) / 2
				elseif nx > co.iw4 - getwidth(sl.player) / 2
					nx = co.iw4 - getwidth(sl.player) / 2
				endif
				
				setPosX(sl.player, nx)

				slThrust(true)
							
			endif

		elseif in.ptrReleased

			slStopSound(sl.hoverSound)
			slThrust(false)
			
			if sl.drop				
				SetSpeed(sl.player, sl.dropSpeed, 180)
			endif
			
		endif
				
	elseif sl.state = STATE_HELP

		slDelete()
		slTitle()

	elseif sl.state = STATE_START

		//colog("play pressed")
		slDelete()
		slCreate()

	elseif sl.state = STATE_END
		
		slDelete()
		slTitle()
		
	elseif sl.state = STATE_WON

	elseif sl.state = STATE_LOST
		
	endif
	 
endfunction

//-----------------------------------------------------
//
function slShowHelp(show as integer, bump as integer)

	local i as integer

	if bump
		
		if sl.helpIdx = sl.helpIdxMax
			sl.helpIdx = 0
		else
			inc sl.helpIdx
		endif

	else

		sl.helpIdx = 0

	endif
	
	setvisible(sl.panel, show)
	setvisible(sl.panel2, show)
	setvisible(sl.nextBut, false)

	for i = 0 to sl.msgs.length
		SetTextVisible(sl.msgs[i], false)
	next

	setvisible(sl.agk2Icon, false)

	if show
		
		if sl.helpIdx = 0

			SetTextString(sl.msgs[1], "Land 5 ships,")
			SetTextString(sl.msgs[2], "one per landing pad.")
			SetTextString(sl.msgs[3], "Tap screen to release ship.")
			SetTextString(sl.msgs[4], "Hold to slow down and")
			SetTextString(sl.msgs[5], "move ship left and right.")
			SetTextString(sl.msgs[6], "Avoid rocks!")
			SetTextString(sl.msgs[7], "Copyright (c) 2017 Paul Sagor")
			
			for i = 0 to 7
				if sl.msgs[i]
					SetTextVisible(sl.msgs[i], true)
				endif
			next

			setvisible(sl.nextBut, true)

		elseif sl.helpIdx = 1

			SetTextString(sl.msgs[1], "Made with AGK")
			SetTextString(sl.msgs[7], "www.appgamekit.com")
			SetTextVisible(sl.msgs[0], true)
			SetTextVisible(sl.msgs[1], true)
			SetTextVisible(sl.msgs[7], true)
			setvisible(sl.agk2Icon, true)
			setvisible(sl.nextBut, true)

		endif

	endif
	
endfunction

//-----------------------------------------------------
//
function slShowButs(show as integer)

	local i as integer
	
	setvisible(sl.playBut, show)
	setvisible(sl.helpBut, show)

	for i = 0 to 2
		setvisible(sl.lives[i], false)
	next

	if not show
		
		for i = 0 to sl.lifeCount - 1
			setvisible(sl.lives[i], true)
		next

	endif
	
endfunction

//-----------------------------------------------------
//
function slShowScores(show as integer, updateBest as integer)

	local i as integer
	local s as string

	i = 0

	s = coGetSetting(sl.settings, "playCount", "0")
	if s = "" then s = "0"

	SetTextString(sl.games, "Games:" + s)
	inc i

	s = coGetSetting(sl.settings, "nbrLandings", "0")
	if s = "" then s = "0"
	SetTextString(sl.landings, "Landings:" + s)

	if updateBest
		
		s = coGetSetting(sl.settings, "bestGameTime", "")
		
		if s = ""
			s = "--:--"
		else
			s = coTimeToString(val(s), false) //true)
		endif
		
		SetTextString(sl.best, "Best:" + s)

	endif

endfunction

//-----------------------------------------------------
//
function slThrust(on as integer)

	local y as float
	local d as float

	if sl.playerFrameIdx = 4
		d = 12
	else
		d = 8
	endif
	
	if on

		if not GetVisible(sl.thrust[0])
			sl.thrustDy = 0
		endif

		y = GetPosy(sl.player) + getheight(sl.player) / 2 + getheight(sl.thrust[0]) / 2 + sl.thrustDy - sl.thrustOffsets[sl.playerFrameIdx]
		setpos(sl.thrust[0], GetPosX(sl.player) - d, y)
		setpos(sl.thrust[1], GetPosX(sl.player) + d, y)
		
		if sl.thrustDy = 0
			sl.thrustDy = 6
		else
			sl.thrustDy = 0
		endif

	endif

	SetVisible(sl.thrust[0], on)
	SetVisible(sl.thrust[1], on)

endfunction

//-----------------------------------------------------
//
function slExplode()

	local cx as float
	local cy as float

	slThrust(false)

	// Explosion.
	cx = getposx(sl.player)
	cy = getposy(sl.player)
	SetSpritePositionByOffset(sl.expl, cx, cy)
	PlaySprite(sl.expl, 10, false)
	SetVisible(sl.player, false)

	slLoser()
	
endfunction

//-----------------------------------------------------
// Land on a base.
//
function slLand()

	local i as integer
	local land as integer
	
	if sl.drop

		land = -1

		for i = 0 to sl.landeds.length

			if getposx(sl.player) > getposx(sl.baseLefts[i]) - getwidth(sl.baseLefts[i]) / 2 and getposx(sl.player) < getposx(sl.baseRights[i]) + getwidth(sl.baseRights[i]) / 2

				if not sl.landeds[i]
					
					land = i
					exit
					
				endif
				
			endif
			
		next

		if land > -1
			slLandShip(land)
		else
			slExplode()
		endif
		
	endif

endfunction

//-----------------------------------------------------
// Duplicate the ship and place it on the landing pad.
//
function slLandShip(idx as integer)

	local landed as integer
	local tmp as string
	local nbrLandings as integer

	slThrust(false)

	// Copy the player to a new landed sprite.
	landed = slCreatePlayerThing(sl.playerFrameIdx)
	//setpos(landed, getposx(sl.player), getposy(sl.player))
	setpos(landed, getposx(sl.player), getposy(sl.baseLefts[idx]) - GetHeight(sl.baseLefts[idx]) + sl.landOffsets[sl.playerFrameIdx])
	sl.landeds[idx] = landed

	inc sl.playerFrameIdx

	tmp = coGetSetting(sl.settings, SL_SETTING_NBR_LANDINGS, "0")

	if tmp = ""
		nbrLandings = 0
	else
		nbrLandings = val(tmp)
	endif

	inc nbrLandings
	
	coSetSetting(sl.settings, SL_SETTING_NBR_LANDINGS, str(nbrLandings))

	if sl.playerFrameIdx = sl.playerFrames.length + 1
		
		SetSpriteImage(sl.win, sl.winImg)
		SetSpriteVisible(sl.win, true)
		coSetSpriteColor(sl.win, co.green[4])
		slWinner()
		
	else
						
		slNextPlayer(true)
		coSaveSettings(SL_SETTING_FILE_NAME, sl.settings) // Save nbr landings.
		slShowScores(true, false)
		slShowHelp(false, false)
						
	endif

endfunction

//-----------------------------------------------------
//
function slCreatePlayerThing(playerFrameIdx as integer)

	local thing as integer
	
	thing = CreateObject(sl.playerImg)
	SetID(thing, LANDED_ID)
	SetSpriteAnimation(getsprite(thing), 96, 96, 10)
	SetSpriteFrame(GetSprite(thing), sl.playerFrames[playerFrameIdx])
	SetSpriteShape(getsprite(thing), 2)
	setscale(thing, sl.playerScales[playerFrameIdx])
	SetDepth(thing, THING_DEPTH)
	SetColGroup(thing, LANDED_ID)

endfunction thing

//-----------------------------------------------------
// Stop movement of everything.
//
function slStopAll()

	local i as integer
	
	SetSpeed(sl.player, 0, 0)

	for i = 0 to sl.rocks.length
		
		setspeed(sl.rocks[i], 0, 0)
		setspin(sl.rocks[i], 0)
		
	next

	stopsound(sl.hoverSound)
	
endfunction

//-----------------------------------------------------
// Play a sound.
//
function slPlaySound(sound as integer, lp as integer)
	
	if sound = sl.hoverSound
		if not sl.hoverSoundInstance
			sl.hoverSoundInstance = PlaySound(sound, 100, lp)
		elseif GetSoundInstancePlaying(sl.hoverSoundInstance) = 0
			sl.hoverSoundInstance = PlaySound(sound, 100, lp)
		endif
	elseif sound = sl.explodeSound
		playsound(sound, 50, lp)
	else
		PlaySound(sound, 100, lp)
	endif		
	
endfunction

//-----------------------------------------------------
// Stop a sound.
//
function slStopSound(sound as integer)

	StopSound(sound)

endfunction

//-----------------------------------------------------
//
function slOnObjUpdate(obj as integer)

	local ang as float
	
	if sl.state <> STATE_PLAY
		exitfunction
	endif
	
	if obj = sl.mother

		if not sl.drop
			
			// Keep mother moving if player haven't dropped yet.
			if getposx(obj) - GetWidth(obj) / 2 < co.iw0 or GetPosX(obj) + GetWidth(obj) / 2 >= co.iw4

				// Flip mother and player direction.
				ang = GetSpeedAngle(sl.mother)	
				ang = -ang

				SetSpeed(sl.mother, sl.motherSpeed, ang)
				SetSpeed(sl.player, sl.motherSpeed, ang)
				
			endif

		else

			// Mother has moved far enough off the screen to not be visible,
			if getposy(obj) < 0 -GetHeight(obj) / 2 - 20
				setspeed(obj, 0, 0)
			endif
			
		endif

	elseif obj = sl.player

		// Accelerate drop like gravity slowly.
		if sl.drop			
			setspeed(sl.player, GetSpeed(sl.player) * 1.02, GetSpeedAngle(sl.player))
		endif
		
	elseif GetID(obj) = ROCK_ID

		// Wrap rocks around screen.
		if getposx(obj) + GetWidth(obj) / 2 < 0
			setposx(obj, co.w + getwidth(obj) / 2)
		elseif getposx(obj) - GetWidth(obj) / 2 > co.w
			setposx(obj, 0 - getwidth(obj) / 2)
		endif

	endif
	
endfunction

//-----------------------------------------------------
function slOnObjTimer(obj as integer)

/*
	local sp as float
	local ang as float
	
	if sl.state <> STATE_PLAY
		exitfunction
	endif

	if sl.drop
		
		sp = GetSpeed(obj)
		ang = GetSpeedAngle(obj)
		SetSpeed(sl.player, sp * 1.1, ang)
		
	endif
*/
	
endfunction

//-----------------------------------------------------
function slOnObjCollision(obj1 as integer, obj2 as integer)

	if sl.state <> STATE_PLAY
		exitfunction
	endif
		
	if getid(obj1) <> getid(obj2)

		if GetColGroup(obj1) = PLAYER_ID

			if GetColGroup(obj2) = ROCK_ID or getcolgroup(obj2) = LANDED_ID

				slPlaySound(sl.explodeSound, false)
				slExplode()
				
			elseif GetColGroup(obj2) = BASE_ID

				slPlaySound(sl.landSound, false)
				slLand()
								
			endif
			
		endif
		
	endif
	
endfunction

//
//
//
