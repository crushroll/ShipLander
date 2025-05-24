#option_explicit

//-----------------------------------------------------
// Key codes.
//
#constant KEY_SHIFT = 16
#constant KEY_ESCAPE = 27
#constant KEY_LEFT = 37
#constant KEY_UP = 38
#constant KEY_RIGHT = 39
#constant KEY_DOWN = 40

//-----------------------------------------------------
global in as Input

type Input

	ptrPressed as integer
	ptrDown as integer
	ptrReleased as integer
	ptrX as float
	ptrY as float
	
endtype

//-----------------------------------------------------
// Setup with seperate input obj.
//
function inInit()

	in.ptrPressed = 0
	in.ptrDown = 0
	in.ptrReleased = 0
	in.ptrX = 0
	in.ptrY = 0
	
endfunction

//-----------------------------------------------------
// Update all input.
//
function inUpdate()

	inPointer()
	
endfunction

//-----------------------------------------------------
//
function inPointer()
		
	in.ptrPressed = GetPointerPressed()
	in.ptrDown = GetPointerState()
	in.ptrReleased = GetPointerReleased()
	in.ptrX = GetPointerX()
	in.ptrY = GetPointerY()


endfunction

//
//
//




