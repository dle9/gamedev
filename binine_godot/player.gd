extends CharacterBody2D


var Bullet = preload("res://bullet.tscn")
var direction = 1 # right
var pressed_key = null


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


var allowed_keys = [
	"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
] + overachiever


func _ready() -> void:
	position = get_viewport().size / 2


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"): # space
		$Sprite2D.flip_h = !$Sprite2D.flip_h
		$Marker2D.position.x *= -1
		direction *= -1
	move_and_slide()


func _input(event) -> void:
	if event is InputEventKey and event.pressed:
		var _mods = str(event).get_slice(", ", 1)
		
		# user input global variables
		var keycode = event.keycode
		var inputted_key = char(keycode)
		var mod = _mods.get_slice("=", 1)
		
		if mod == "Shift":
			if allowed_shift.has(inputted_key):
				pressed_key = allowed_shift[inputted_key]
		else:
			pressed_key = inputted_key
			
		if pressed_key in allowed_keys:
			shoot()


func shoot() -> void:
	var b = Bullet.instantiate()
	b.velocity.x = direction
	b.key = pressed_key
	
	get_parent().add_child(b)
	b.position = $Marker2D.global_position
