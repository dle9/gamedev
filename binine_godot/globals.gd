extends Node


# viewport: 1824 x 864
# sprite height = 96
# 864/96 = 9 rows


@onready var row0_label = get_node("/root/world/Row0/HBoxContainer/Label")
@onready var row1_label = get_node("/root/world/Row1/HBoxContainer/Label")
@onready var row2_label = get_node("/root/world/Row2/HBoxContainer/Label")
@onready var row3_label = get_node("/root/world/Row3/HBoxContainer/Label")
@onready var row4_label = get_node("/root/world/Row4/HBoxContainer/Label")
@onready var row5_label = get_node("/root/world/Row5/HBoxContainer/Label")
@onready var row6_label = get_node("/root/world/Row6/HBoxContainer/Label")
@onready var row7_label = get_node("/root/world/Row7/HBoxContainer/Label")
@onready var row8_label = get_node("/root/world/Row8/HBoxContainer/Label")


var enemy_speeds = [50, 100, 150, 200, 250, 300]
var enemy_pos_x = [0, 1824]
var is_lvl_1 = false
var is_lvl_2 = false
var is_lvl_3 = false


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


var row_legend = []


func _ready():
	row_legend = generate_rows("essential")
	
	
func calc_row_pos_y(row: int) -> int:
	var sprite_height = 96
	var row_pos_y = (sprite_height * row) + sprite_height/2
	return row_pos_y
	

func generate_word_bar() -> String:
	'''generate the enemy hp bar'''
	
	var possible_lengths = null
	if possible_lengths == null or Globals.is_lvl1:
		possible_lengths = [3]
	if Globals.is_lvl_2:
		possible_lengths = [3, 6]
	if Globals.is_lvl_3:
		possible_lengths = [3, 6, 9]
		
	var length = possible_lengths[randi() % possible_lengths.size()]
	
	var result = ""
	
	for i in range(length):
		result += generate_random_letter()
	
	return result
	
	
func generate_random_letter() -> String:
	return alphabet[randi() % alphabet.size()].to_lower()
	
	
func kill() -> void:
	get_tree().quit()
