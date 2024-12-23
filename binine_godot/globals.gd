extends Node


var essential = [
	",", ".", "/", ";", "'", "-", "=", ":", "\"", "_", "(", ")", "{", "}"
]
var questionable = [
	"<", ">", "?", "!", "\\", "[", "]"
] + essential
var overachiever = [
	"1", "2", "3", "4", "5", "6", "7", "8", "9", "0", 
	"#", "$", "%", "^", "&", "*"
] + questionable + essential


var allowed_shift = {
	",": "<",
	".": ">",
	"/": "?",
	";": ":",
	"'": "\"",
	"[": "{",
	"]": "}",
	"-": "_",
	"1": "!",
	"2": "@",
	"3": "#",
	"4": "$",
	"5": "%",
	"6": "^",
	"7": "&",
	"8": "*",
	"9": "(",
	"0": ")",
}


var alphabet = [
	"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
]


func generate_rows(difficulty) -> Array:
	var arr = null
	
	if difficulty == "essential":
		arr = essential
	elif difficulty == "questionable":
		arr = questionable
	elif difficulty == "overachiever":
		arr = overachiever
	else:
		arr = essential
		
	arr.shuffle()
	return arr.slice(0, 9)
