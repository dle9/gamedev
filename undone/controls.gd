extends Node


var allowed_shift = {
	"a": "A","b": "B","c": "C","d": "D","e": "E","f": "F","g": "G","h": "H","i": "I","j": "J","k": "K","l": "L","m": "M","n": "N","o": "O","p": "P","q": "Q","r": "R","s": "S","t": "T","u": "U","v": "V","w": "W","x": "X","y": "Y","z": "Z",
	",": "<",".": ">","/": "?",";": ":","'": "\"","[": "{","]": "}","-": "_","\\": "|","`": "~","=": "+",
	"1": "!","2": "@","3": "#","4": "$","5": "%","6": "^","7": "&","8": "*","9": "(","0": ")"
}


func handle_key_press(event: InputEventKey) -> String:
	var mods = str(event).get_slice(", ", 1)
	var pressed_key = null
	
	# user input global variables
	var keycode = event.keycode
	var mod = mods.get_slice("=", 1)
	
	var inputted_key = null
	if keycode > -1 and keycode < 256:
		inputted_key = char(keycode)
		
		if mod == "Shift":
			if Controls.allowed_shift.has(inputted_key):
				pressed_key = Controls.allowed_shift[inputted_key]
		else:
			pressed_key = inputted_key
			
	return pressed_key
