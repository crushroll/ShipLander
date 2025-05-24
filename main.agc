#option_explicit

#include "common.agc"
#include "input.agc"
#include "fantomEngine.agc"
#include "shiplander.agc"

//-----------------------------------------------------
// Set up window.
//
SetOrientationAllowed(1, 1, 0, 0)
SetWindowTitle("Ship Lander")
//SetWindowSize(700, 1280, false)
SetVirtualResolution(768, 1136)
SetIntendedDeviceSize(768, 1136)

//SetAdMobDetails("ca-app-pub-3359100048392078/9758071542")

// 640x960 is the central area to work nicely on any device.
// iPhone 6s 1334x750
// iPhone 6 1920x1080
// iPhone SE 1136x640

//-----------------------------------------------------
// Init.
//
global ma as Main

type Main

	delta as float
	adsOn as integer

endtype

//-----------------------------------------------------
// MAIN LINE CODE.
//
setPrintColor(255, 255, 255)
SetPrintSize(24)
//coSetClearColor(co.black)
//SetBorderColor(128, 0, 0)

ma.adsOn = true

coInit()
coInitAds()
coLogTop(true)
maInit()

//-----------------------------------------------------
// Main loop.
//

do
	
	ClearScreen()

	maUpdate()
	print(co.log)
	
	ma.delta = GetFrameTime() * 60
	UpdateAllObjects(ma.delta)
	CheckAllCollisions()
	
	Sync()
	
	//if GetRawKeyPressed(KEY_ESCAPE) then exit

loop

maDestroy()

end

//-----------------------------------------------------
//
function maInit()

	inInit()
	slInit()

endfunction

//-----------------------------------------------------
//
function maDestroy()
	
endfunction

//-----------------------------------------------------
//
function maUpdate()

	inUpdate()
	slUpdate()

endfunction

//-----------------------------------------------------
//
function OnObjTimer(obj as integer)

	slOnObjTimer(obj)
		
endfunction

//-----------------------------------------------------
function OnObjCollision(obj1 as integer, obj2 as integer)

	slOnObjCollision(obj1, obj2)
	
endfunction

//-----------------------------------------------------
function OnObjUpdate(obj as integer)

	slOnObjUpdate(obj)

endfunction
