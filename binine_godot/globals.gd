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
	'''assign a unique key to each 
	of the nine 9 player rows'''
	
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
	
	
func generate_word_bar() -> String:
	'''generate the enemy hp bar'''
	
	var possible_lengths = [3, 6, 9]
	var length = possible_lengths[randi() % possible_lengths.size()]
	
	var result = ""
	
	for i in range(length):
		var letter = alphabet[randi() % alphabet.size()]
		result += letter.to_lower()
	
	return result


func kill() -> void:
	get_tree().reload_current_scene()
