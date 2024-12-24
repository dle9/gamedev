extends CharacterBody2D


var Bullet = preload("res://bullet.tscn")
var direction = 1 # right
var pressed_key = null
var is_key_held = false


func _ready() -> void:
	position = set_row_position(0)
	
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"): # space
		$Sprite2D.flip_h = !$Sprite2D.flip_h
		$Marker2D.position.x *= -1
		$laser.position.x *= -1
		direction *= -1
		
	move_and_slide()
	
	
func _input(event) -> void:
	if event is InputEventKey && event.pressed:
		handle_key_press(event)
		
		
func handle_key_press(event: InputEventKey) -> void:
	var mods = str(event).get_slice(", ", 1)
	
	# user input global variables
	var keycode = event.keycode
	var mod = mods.get_slice("=", 1)
	
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
			var row_index = Globals.row_legend.find(pressed_key)
			if row_index > -1 and row_index < 10:
				position = set_row_position(row_index)
		
		
func set_row_position(row: int) -> Vector2:
	return Vector2(get_viewport().size.x / 2, Globals.calc_row_pos_y(row))
	
	
func shoot() -> void:
	var b = Bullet.instantiate()
	b.velocity.x = direction
	b.key = pressed_key
	
	get_parent().add_child(b)
	b.position = $Marker2D.global_position
