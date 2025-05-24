
#option_explicit

//
// Common code.
//

//-----------------------------------------------------
// Booleans.
//
#constant FALSE = 0
#constant TRUE = 1

//-----------------------------------------------------
// General purpose directions.

#constant DIR_N = 1
#constant DIR_S = 2
#constant DIR_E = 4
#constant DIR_W = 8

// General purpose edges.
//
#constant EDGE_TOP = 1
#constant EDGE_BOTTOM = 2
#constant EDGE_LEFT = 4
#constant EDGE_RIGHT = 8


#constant FRONT_DEPTH = 10
#constant GUI_VALUE_DEPTH = 20
#constant GUI_CTRL_DEPTH = 30
#constant GUI_BACK_DEPTH = 40
#constant PLAYER_DEPTH = 50
#constant ENEMY_DEPTH = 60
#constant THING_DEPTH = 70
#constant SCENE_DEPTH = 80
#constant BACK_DEPTH = 100

#constant STATE_NONE 0
#constant STATE_PLAY 1
#constant STATE_WON 2
#constant STATE_LOST 3
#constant STATE_HELP 4
#constant STATE_SETTINGS 5
#constant STATE_BACK 6
#constant STATE_START 7
#constant STATE_END 8
#constant STATE_COUNTER 9

//-----------------------------------------------------
// Drag distance before a touch becomes a drag.
//
#constant DRAG_SIZE_MIN = 20 // The minimum distance a drag needs to be to not just be a touch.

//-----------------------------------------------------
// Strip chars for a file name.
//
#constant DELIMS$ = " ~!@#$%^&*()_+`-=[]\[]\;':,./<>?" + chr(34)

//-----------------------------------------------------
global co as Common

//-----------------------------------------------------
type Common
	
	log as string
	logTop as integer
	logNbr as integer
	
	pix as integer
	
	cs as float // Width of one block, e.g. 8
	bs as float // Width of a square button.
	w as float
	h as float
	w1 as float
	w2 as float
	w3 as float
	iw as float
	iw0 as float
	iw1 as float
	iw2 as float
	iw3 as float
	iw4 as float
	h1 as float
	h2 as float
	h3 as float
	ih as float
	ih0 as float
	ih1 as float
	ih2 as float
	ih3 as float
	ih4 as float
	tabW as float
	
	red as integer[9]
	blue as integer[9]
	green as integer[9]
	deeppurple as integer[9]
	yellow as integer[9]
	pink as integer[9]
	orange as integer[9]
	indigo as integer[9]
	amber as integer[9]
	deeporange as integer[9]
	grey as integer[9]
	brown as integer[9]
	lightgreen as integer[9]
	lime as integer[9]
	teal as integer[9]
	lightblue as integer[9]
	cyan as integer[9]
	purple as integer[9]
	bluegrey as integer[9]
	white as integer
	black as integer
	
	font1 as integer
	f1size as float
	font2 as integer
	f2size as float
	font3 as integer
	f3size as float
	
endtype

type KVPair

	k as string
	v as string
	
endtype

//-----------------------------------------------------
function coInit()
	
	co.log = ""
	co.logTop = false
	co.logNbr = 1
	
	co.pix = LoadImage("gfx/pix.png")

	co.cs = 16
	co.bs = co.cs * 8
	co.w = GetVirtualWidth()
	co.h = GetVirtualHeight()
	co.w1 = co.w / 4
	co.w2 = co.w / 2
	co.w3 = co.w2 + co.w1
	co.iw = co.w / 6 * 5	
	co.iw0 = (co.w - co.iw) / 2
	co.iw1 = co.w1 / 4
	co.iw2 = co.w / 2
	co.iw3 = co.iw2 + co.iw1
	co.iw4 = co.w - co.iw0
	co.h1 = co.h / 4
	co.h2 = co.h / 2
	co.h3 = co.h2 + co.h1
	co.ih = co.h / 71 * 60
	co.ih0 = (co.h - co.ih) / 2
	co.ih1 = co.ih / 4
	co.ih2 = co.h / 2
	co.ih3 = co.h2 + co.ih1
	co.ih4 = co.h - co.ih0
	co.tabW = co.h
	
	co.red[1] = coMakeHexColor("FFCDD2")
	co.red[2] = coMakeHexColor("EF9A9A")
	co.red[4] = coMakeHexColor("EF5350")
	co.red[7] = coMakeHexColor("D32F2F")	
	co.blue[1] = coMakeHexColor("BBDEFB")
	co.blue[2] = coMakeHexColor("64B5F6")
	co.blue[4] = coMakeHexColor("42A5F5")
	co.blue[7] = coMakeHexColor("1976D2")
	co.green[1] = coMakeHexColor("C8E6C9")
	co.green[2] = coMakeHexColor("81C784")
	co.green[4] = coMakeHexColor("66BB6A")
	co.green[7] = coMakeHexColor("388E3C")
	co.deeppurple[1] = coMakeHexColor("D1C4E9")
	co.deeppurple[2] = coMakeHexColor("9575CD")
	co.deeppurple[4] = coMakeHexColor("7E57C2")
	co.deeppurple[7] = coMakeHexColor("512DA8")
	co.yellow[1] = coMakeHexColor("FFF9C4")
	co.yellow[2] = coMakeHexColor("FFF176")
	co.yellow[4] = coMakeHexColor("FFEE58")
	co.yellow[7] = coMakeHexColor("FBC02D")
	co.amber[1] = coMakeHexColor("FFECB3")
	co.amber[2] = coMakeHexColor("FFD54F")
	co.amber[4] = coMakeHexColor("FFCA28")
	co.amber[7] = coMakeHexColor("FFA000")	
	co.pink[1] = coMakeHexColor("F8BBD0")
	co.pink[2] = coMakeHexColor("F06292")
	co.pink[4] = coMakeHexColor("EC407A")
	co.pink[7] = coMakeHexColor("C2185B")
	co.orange[1] = coMakeHexColor("FFE0B2")
	co.orange[2] = coMakeHexColor("FFB74D")
	co.orange[4] = coMakeHexColor("FFA726")
	co.orange[7] = coMakeHexColor("F57C00")
	co.deeporange[1] = coMakeHexColor("FFE0B2")
	co.deeporange[2] = coMakeHexColor("FF8A65")
	co.deeporange[4] = coMakeHexColor("FF7043")
	co.deeporange[7] = coMakeHexColor("E64A19")
	co.indigo[1] = coMakeHexColor("C5CAE9")
	co.indigo[2] = coMakeHexColor("7986CB")
	co.indigo[4] = coMakeHexColor("5C6BC0")
	co.indigo[7] = coMakeHexColor("303F9F")
	co.indigo[9] = coMakeHexColor("1A237E")
	co.brown[1] = coMakeHexColor("D7CCC8")
	co.brown[2] = coMakeHexColor("A1887F")
	co.brown[4] = coMakeHexColor("8D6E63")
	co.brown[7] = coMakeHexColor("5D4037")	
	co.grey[0] = coMakeHexColor("FAFAFA")
	co.grey[1] = coMakeHexColor("F5F5F5")
	co.grey[2] = coMakeHexColor("EEEEEE")
	co.grey[3] = coMakeHexColor("E0E0E0")
	co.grey[4] = coMakeHexColor("BDBDBD")
	co.grey[5] = coMakeHexColor("9E9E9E")	
	co.grey[6] = coMakeHexColor("757575")
	co.grey[7] = coMakeHexColor("616161")
	co.grey[8] = coMakeHexColor("424242")
	co.grey[9] = coMakeHexColor("212121")
	co.lightgreen[1] = coMakeHexColor("DCEDC8")
	co.lightgreen[2] = coMakeHexColor("AED581")
	co.lightgreen[4] = coMakeHexColor("9CCC65")
	co.lightgreen[7] = coMakeHexColor("689F38")
	co.lime[1] = coMakeHexColor("F0F4C3")
	co.lime[2] = coMakeHexColor("DCE775")
	co.lime[4] = coMakeHexColor("D4E157")
	co.lime[7] = coMakeHexColor("AFB42B")
	co.teal[1] = coMakeHexColor("B2DFDB")
	co.teal[2] = coMakeHexColor("4DB6AC")
	co.teal[4] = coMakeHexColor("26A69A")
	co.teal[7] = coMakeHexColor("00796B")
	co.lightblue[1] = coMakeHexColor("B3E5FC")
	co.lightblue[2] = coMakeHexColor("4FC3F7")
	co.lightblue[4] = coMakeHexColor("29B6F6")
	co.lightblue[7] = coMakeHexColor("0288D1")
	co.lightblue[9] = coMakeHexColor("01579B")
	co.cyan[1] = coMakeHexColor("B2EBF2")
	co.cyan[2] = coMakeHexColor("4DD0E1")
	co.cyan[4] = coMakeHexColor("26C6DA")
	co.cyan[7] = coMakeHexColor("0097A7")
	co.purple[1] = coMakeHexColor("E1BEE7")
	co.purple[2] = coMakeHexColor("BA68C8")
	co.purple[4] = coMakeHexColor("AB47BC")
	co.purple[7] = coMakeHexColor("7B1FA2")
	co.bluegrey[1] = coMakeHexColor("CFD8DC")
	co.bluegrey[2] = coMakeHexColor("B0BEC5")
	co.bluegrey[3] = coMakeHexColor("90A4AE")
	co.bluegrey[4] = coMakeHexColor("78909C")
	co.bluegrey[5] = coMakeHexColor("607D8B")
	co.bluegrey[6] = coMakeHexColor("546E7A")
	co.bluegrey[7] = coMakeHexColor("455A64")
	co.bluegrey[9] = coMakeHexColor("263238")
	
	co.white = coMakeHexColor("FFFFFF")
	co.black = coMakeHexColor("000000")
		
	co.font1 = loadimage("fonts/Roboto50.png")
	co.f1size = 50
	co.font2 = loadimage("fonts/Roboto80.png")
	co.f2size = 80
	co.font3 = loadimage("fonts/Roboto100.png")
	co.f3size = 100

endfunction

//-----------------------------------------------------
// Log a message ready to print.
//
function coLog(msg as string)

	if co.logTop
		co.log = str(co.logNbr) + ": " + msg + chr(10) + co.log
	else
		co.log = co.log + str(co.logNbr) + ": " + msg + chr(10)
	endif
	
	co.logNbr = co.logNbr + 1
	
endfunction

//-----------------------------------------------------
function coMessage(msg as string)
	
	//coLog(msg$)
	message(msg)
	
endfunction

//-----------------------------------------------------
// Log a message ready to print.
//
function coLogClear()
	
	co.log = ""
	co.logNbr = 1
	
endfunction

//-----------------------------------------------------
// Set the log point.
// logTop=true for prepend, or false for append.
//
function coLogTop(logTop as integer)
	
	co.logTop = logTop
	
endfunction

//-----------------------------------------------------
// IMAGES / SPRITES

//-----------------------------------------------------
// Load an image.
//
function coLoadImage(name$)
	
	img as integer
	
	img = LoadImage(name$ + "@2x.png")
	
endfunction img

//-----------------------------------------------------
// Create a box.
//
function coCreateBox(w, h)
	
	spr as integer	
	spr = CreateSprite(co.pix)
	SetSpriteScale(spr, w, h)
	
endfunction spr

//-----------------------------------------------------
// Check whether the rect(ax, ay, aw, ah) is within the rect (bx, by, bw, bh)
//
function coRectOverlapsRect(ax as float, ay as float, aw as float, ah as float, bx as float, by as float, bw as float, bh as float)
		
	local ret as integer
	
	If ax > bx + bw - 1 Or ax + aw - 1 < bx Or ay > by + bh - 1 Or ay + ah - 1 < by
		ret = False
	else
		ret = True
	endif
	
endfunction ret

//-----------------------------------------------------
// Check whether the rect(ax, ay, aw, ah) is on the edge of rect (bx, by, bw, bh)
// That is, one or two edges of a are outside the edges of b, while the other two are within
//
function coRectEdgesRect(ax as float, ay as float, aw as float, ah as float, bx as float, by as float, bw as float, bh as float)
		
	local ret as integer

	ret = 0
	
	If (ax < bx + bw - 1 and ax + aw - 1 > bx + bw - 1)
		ret = ret + EDGE_RIGHT
	endif
	
	if (ax < bx and ax + aw - 1 > bx)
		ret = ret + EDGE_LEFT
	endif
	
	if (ay < by + bh - 1 and ay + ah - 1 > by + bh - 1)
		ret = ret + EDGE_BOTTOM
	endif
	
	if (ay < by and ay + ah - 1 > by)
		ret = ret + EDGE_TOP
	endif
	
endfunction ret

//-----------------------------------------------------
// Check whether the spr was hit with a touch position of (x, y) plus edge around (l, r, t, b)
// Uses a rect method instead of GetSpriteHitTest.
// NOTE: assumes ByOffset positioning.
//
function coGetSpriteHitTest(spr as integer, x as float, y as float, extra as float)
		
	local ret as integer

	ret = coGetSpriteHitTest3(spr, x, y, extra, extra, extra, extra)

endfunction ret

//-----------------------------------------------------
// Check whether the spr was hit with a touch position of (x, y) plus edge around (l, r, t, b)
// Uses a rect method instead of GetSpriteHitTest.
// NOTE: assumes ByOffset positioning.
//
function coGetSpriteHitTest2(spr as integer, x as float, y as float, horiz as float, vert as float)
		
	local ret as integer

	ret = coGetSpriteHitTest3(spr, x, y, horiz, horiz, vert, vert)

endfunction ret

//-----------------------------------------------------
// Check whether the spr was hit with a touch position of (x, y) plus edge around (l, r, t, b)
// Uses a rect method instead of GetSpriteHitTest.
// NOTE: assumes ByOffset positioning.
//
function coGetSpriteHitTest3(spr as integer, x as float, y as float, l as float, r as float, t as float, b as float)
		
	local ret as integer

	ret = coPointWithinRect(x, y, GetSpriteXByOffset(spr) - GetSpriteWidth(spr) / 2 - l, GetSpriteYByOffset(spr) - GetSpriteHeight(spr) / 2 - t, l + GetSpriteWidth(spr) + r, t + GetSpriteHeight(spr) + b)

endfunction ret

//-----------------------------------------------------
// Check whether rect1 (ax, ay, aw, ah) overlaps rect (bx, by, bw, bh)
//
function coPointWithinRect(px as float, py as float, x as float, y as float, w as float, h as float)
		
	local ret as integer
	
	if px >= x And px < x + w And py >= y And py < y + h
		ret = true
	else
		ret = false
	endif
	
endfunction ret

//-----------------------------------------------------
// Given a hex string, return a makecolor value.
//
function coMakeHexColor(hex$)
	
	local r as integer
	local g as integer
	local b as integer

	r = val(mid(hex$, 1, 2), 16)
	g = val(mid(hex$, 3, 2), 16)
	b = val(mid(hex$, 5, 2), 16)
	
	local ret as integer
	ret = makecolor(r, g, b)
	
endfunction ret

//-----------------------------------------------------
// Set the color of the clear color.
//
function coSetClearColor(col as integer)
	
	SetClearColor(getcolorred(col), getcolorgreen(col), getcolorblue(col))

endfunction
//-----------------------------------------------------
// Set the color of the passed sprite using bit pattern color.
//
function coSetSpriteColor(spr as integer, col as integer)
	
	SetSpriteColor(spr, getcolorred(col), getcolorgreen(col), getcolorblue(col), 255)

endfunction

//-----------------------------------------------------
// Get the color of the passed sprite returning a bit pattern color.
//
function coGetSpriteColor(spr as integer)
	
	ret as integer
	ret = makecolor(getspritecolorred(spr), getspritecolorgreen(spr), getspritecolorblue(spr))

endfunction ret

//-----------------------------------------------------
// Set the color of the passed text using bit pattern color.
//
function coSetTextColor(spr as integer, col as integer)
	
	SetTextColor(spr, getcolorred(col), getcolorgreen(col), getcolorblue(col), 255)

endfunction

//-----------------------------------------------------
// Display the passed 'millis' int as hh:mm:ss
//
function coTimeToString(millis as integer, frac as integer)

	local h as integer
	local m as integer
	local s as integer
	local f as integer // Hundreths.
	local div as integer

	div = (1000 * 60 * 60)
	h = millis / div
	millis = millis - h * div
	
	div = (1000 * 60)
	m = millis / div
	millis = millis - m * div

	div = 1000
	s = millis / div
	millis = millis - s * div

	f = round(millis / 10.0)

	local ret as string

	if h > 0

		ret = ret + right("00" + str(h), 2)
		ret = ret + ":"

	endif
	
	ret = ret + right("00" + str(m), 2)
	ret = ret + ":"
	ret = ret + right("00" + str(s), 2)

	if frac

		ret = ret + "."
		ret = ret + right("00" + str(f), 2)

	endif

endfunction ret

//-----------------------------------------------------
function coBoolToString(bool as integer)

	local ret as string

	if bool
		ret = "true"
	else
		ret = "false"
	endif
	
endfunction ret

//-----------------------------------------------------
function coStringToBool(text as string)

	local ret as integer

	if lower(text) = "true"
		ret = 1
	else
		ret = 0
	endif
	
endfunction ret

//-----------------------------------------------------
// Convert a dir to a string.
// longStyle false for single letter, true for lower full name.
//
function coDirToString(dir as integer, longStyle as integer)

	local ret as string

	if dir = DIR_N
		if longStyle then ret = "north" else ret = "n"
	elseif dir = DIR_S
		if longStyle then ret = "south" else ret = "s"
	elseif dir = DIR_W
		if longStyle then ret = "west" else ret = "w"
	elseif dir = DIR_E
		if longStyle then ret = "east" else ret = "e"
	endif
		
endfunction ret

//-----------------------------------------------------
// Get a direction, based on an angle.
// If fuzzy is true, then the ang will be "forced" to a 90 degree angle.
//
function coAngleToDir(ang as float, fuzzy as integer)

	local dir as integer

	ang = mod(ang, 360)

	if fuzzy
		ang = (ang / 90) * 90
	endif
	
	if ang = 0
		dir = DIR_N
	elseif ang = 90
		dir = DIR_E
	elseif ang = 180
		dir = DIR_S
	elseif ang = 270
		dir = DIR_W
	endif

endfunction dir

//-----------------------------------------------------
// Get the angle for the passed dir.
//
function coDirToAngle(dir as integer)

	local ang as float
	
	if dir = DIR_E
		ang = 90
	elseif dir = DIR_S
		ang = 180
	elseif dir = DIR_W
		ang = 270
	else//if dir = DIR_N
		ang = 0
	endif

endfunction ang

//-----------------------------------------------------
// Creates a string with 's' repeated 'count' times.
//
function coRepeatString(s as string, count as integer)

	local ret as string
	local i as integer

	for i = 1 to count
		ret = ret + s
	next
	
endfunction ret

//-----------------------------------------------------
// Fill 'arr' with value 'v'.
//
function coFillArray(arr ref as integer[], v as integer)

	local i as integer

	for i = 0 to arr.length - 1
		arr[i] = v
	next

endfunction

// --------------------------------------------------------------------
// Make an integer value combining x as top 16 bits, and y as bottom 16 bits.
//
function coMakePoint(x as integer, y as integer)

	local v as integer
	v = x << 16
	v = v + y
	//colog("x=" + str(x) + ", y=" + str(y) + ", v=" + str(v))
	
endfunction v

// --------------------------------------------------------------------
// Return the x portion of a maze point.
//
function coGetPointX(pt as integer)

	local x as integer
	x = (pt >> 16) && 0x0000ffff
	//colog("pt=" + str(pt) + ", x=" + str(x))
	
endfunction x

// --------------------------------------------------------------------
// Return the y portion of a maze point.
//
function coGetPointY(pt as integer)

	local y as integer
	y = pt && 0x0000ffff
	//colog("pt=" + str(pt) + ", y=" + str(y))
	
endfunction y

// --------------------------------------------------------------------
// Get a string rep of a pt.
//
function coPointToString(pt as integer)

	local s as string

	s = "(" + str(coGetPointX(pt)) + "," + str(coGetPointY(pt)) + ")"
	
endfunction s

// --------------------------------------------------------------------
// Create a color streak (list of colors) starting from firstCol, ending at lastCol.
//
function coCalcColorRange(cols ref as integer[], steps as float, firstCol as integer, lastCol as integer)

	local i as integer
	local ratio as float
	local red as integer
	local green as integer
	local blue as integer
	local newCol as integer
	//local cols as integer[]
	
	for i = 0 to steps - 1
	
		ratio = i / steps
		red = GetColorRed(lastCol) * ratio + GetColorRed(firstCol) * (1 - ratio)
		green = GetColorGreen(lastCol) * ratio + GetColorGreen(firstCol) * (1 - ratio)
		blue = GetColorBlue(lastCol) * ratio + GetColorBlue(firstCol) * (1 - ratio)		
		newCol = MakeColor(red, green, blue)
		//colog("ratio=" + str(ratio) + ", r=" + str(red) + ", g=" + str(green) + ", b=" + str(blue))
		cols.insert(newCol)

	next

endfunction

//-----------------------------------------------------
// Delete the settings file.
//
function coDeleteSettings(fileName as string)

	DeleteFile(fileName)
	
endfunction

//-----------------------------------------------------
// Load a file containing a list of k=v lines.
//
function coLoadSettings(fileName as string, list ref as KVPair[])

	local file as integer
	local line as string
	local pair as KVPair
	
	file = OpenToRead(fileName)
	
	if file
		
		while not FileEOF(file)
			
			line = ReadLine(file)
			pair.k = GetStringToken2(line, "=", 1)
			pair.v = GetStringToken2(line, "=", 2)
			coInsertSetting(list, pair)

		endwhile

	endif
	
	CloseFile(file)
	
endfunction

//-----------------------------------------------------
// Insert a pair into the list.
// If the pair's k already exists, replace the value only.
//
function coInsertSetting(list ref as KVPair[], pair ref as KVPair)

	local i as integer
	local found as integer

	found = false
	
	for i = 0 to list.length
		
		if list[i].k = pair.k

			list[i].v = pair.v
			found = true
			
		endif
		
	next

	if not found
		list.insert(pair)
	endif
	
endfunction

//-----------------------------------------------------
// Insert a pair into the list.
// If the pair's k already exists, replace the value only.
//
function coSetSetting(list ref as KVPair[], k as string, v as string)

	local i as integer
	local found as integer
	local pair as KVPair

	found = false
	
	for i = 0 to list.length
		
		if list[i].k = k

			list[i].v = v
			found = true
			
		endif
		
	next

	if not found

		pair.k = k
		pair.v = v
		list.insert(pair)
		
	endif
	
endfunction

//-----------------------------------------------------
// Find a value for a given k (key) into thr settings list.
//
function coGetSetting(list ref as KVPair[], k as string, def as string)

	local i as integer
	local ret as string

	ret = def
	
	for i = 0 to list.length
		
		if list[i].k = k

			ret = list[i].v
			
		endif
		
	next
	
endfunction ret

//-----------------------------------------------------
// Save a list of k=v (Key-value pairs) into the passed file.
//
function coSaveSettings(fileName as string, list ref as KVPair[])

	local file as integer
	local i as integer
	
	file = opentowrite(fileName)

	if file

		for i = 0 to list.length
			writeline(file, list[i].k + "=" + list[i].v)
		next
		
	endif

	CloseFile(file)
	
endfunction

//-----------------------------------------------------
//
function coInitAds() 
 
        select GetDeviceType() //just an array with the contents of getDeviceType()
 
            case "ios"
                SetAdMobDetails("ca-app-pub-3359100048392078/9758071542") //pushdown_full_ios_admob_interstit
 
            endcase
 
            case "android"                
                setAdMobDetails("ca-app-pub-xxxxxxxxxxxxxxx/xxxxxxxxxxxxxxx") //pushdown_android_admob_banner
 
            endcase
        endselect
 
endfunction

//-----------------------------------------------------
//
function coDisplayAdvertBanner()
//call this when you want a banner ad
 
        CreateAdvert(3, 1, 2, 0)
		SetAdvertLocation(1, 0, 0)
        SetAdvertVisible(true)
        RequestAdvertRefresh()
 
endfunction

//-----------------------------------------------------
//
function coDisplayAdvertFullscreen()
//call this when you want a full screen ad
 
        coInitAds() 
        //PauseMusic() //full screen ads sometimes have sounds/music
        CreateFullscreenAdvert()
        SetAdvertVisible(true)
        RequestAdvertRefresh()
 
endfunction

//
// End.
//
