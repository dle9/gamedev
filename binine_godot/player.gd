extends CharacterBody2D


var difficulty = "essential" # essential, questionable, overachiever
var Bullet = preload("res://bullet.tscn")
var direction = 1 # right
var pressed_key = null
var rows = null


func _ready() -> void:
	position = get_viewport().size / 2
	rows = Globals.generate_rows(difficulty)
	
	
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
		var mod = _mods.get_slice("=", 1)
		
		var inputted_key = null
		if keycode > -1 and keycode < 256:
			inputted_key = char(keycode)
		
		if mod == "Shift":
			if Globals.allowed_shift.has(inputted_key):
				pressed_key = Globals.allowed_shift[inputted_key]
		else:
			pressed_key = inputted_key
			
		if pressed_key in Globals.alphabet:
			shoot()
		else:
			var row_index = rows.find(pressed_key)
			
			
func shoot() -> void:
	var b = Bullet.instantiate()
	b.velocity.x = direction
	b.key = pressed_key
	
	get_parent().add_child(b)
	b.position = $Marker2D.global_position
