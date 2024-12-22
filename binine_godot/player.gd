extends CharacterBody2D

var bullet_speed = 2000
var Bullet = preload("res://bullet.tscn")
var sprite = null

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

func _ready() -> void:
	position = get_viewport().size / 2
	sprite = $Sprite2D
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		sprite.flip_h = !sprite.flip_h
	
	move_and_slide()

func _input(event) -> void:
	if event is InputEventKey and event.pressed:
		var _mods = str(event).get_slice(", ", 1)
		
		# user input global variables
		var keycode = event.keycode
		var inputted_key = char(keycode)
		var pressed_key = null # stores the actual pressed key
		var mod = _mods.get_slice("=", 1)
		var direction := Input.get_axis("ui_left", "ui_right")
		
		if mod == "Shift":
			if allowed_shift.has(inputted_key):
				pressed_key = allowed_shift[inputted_key]
		else:
			pressed_key = inputted_key
		
func fire() -> void:
	var bullet = Bullet.instance()
	bullet.position = get_global_position()
	bullet.apply_impulse(Vector2(), Vector2(bullet_speed, 0))
	get_tree().get_root().call_deferred("add_child", bullet)
