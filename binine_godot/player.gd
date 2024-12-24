extends CharacterBody2D


var difficulty = "essential" # essential, questionable, overachiever
var Bullet = preload("res://bullet.tscn")
var direction = 1 # right
var pressed_key = null
var is_key_held = false
var row_legend = null


@onready var row0_label = get_parent().get_node("Row0/HBoxContainer/Label")
@onready var row1_label = get_parent().get_node("Row1/HBoxContainer/Label")
@onready var row2_label = get_parent().get_node("Row2/HBoxContainer/Label")
@onready var row3_label = get_parent().get_node("Row3/HBoxContainer/Label")
@onready var row4_label = get_parent().get_node("Row4/HBoxContainer/Label")
@onready var row5_label = get_parent().get_node("Row5/HBoxContainer/Label")
@onready var row6_label = get_parent().get_node("Row6/HBoxContainer/Label")
@onready var row7_label = get_parent().get_node("Row7/HBoxContainer/Label")
@onready var row8_label = get_parent().get_node("Row8/HBoxContainer/Label")


func _ready() -> void:
	position = set_row_position(0)
	
	row_legend = Globals.generate_rows(difficulty)
	row0_label.text = row_legend[0]
	row1_label.text = row_legend[1]
	row2_label.text = row_legend[2]
	row3_label.text = row_legend[3]
	row4_label.text = row_legend[4]
	row5_label.text = row_legend[5]
	row6_label.text = row_legend[6]
	row7_label.text = row_legend[7]
	row8_label.text = row_legend[8]
	
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"): # space
		$Sprite2D.flip_h = !$Sprite2D.flip_h
		$Marker2D.position.x *= -1
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
			var row_index = row_legend.find(pressed_key)
			if row_index > -1 and row_index < 10:
				position = set_row_position(row_index)
		
		
func set_row_position(row: int) -> Vector2:
	return Vector2(get_viewport().size.x / 2, calc_row_pos_y(row))
	
	
func shoot() -> void:
	var b = Bullet.instantiate()
	b.velocity.x = direction
	b.key = pressed_key
	
	get_parent().add_child(b)
	b.position = $Marker2D.global_position
	
	
func calc_row_pos_y(row: int) -> int:
	var sprite_height = 96
	var row_pos_y = (sprite_height * row) + sprite_height/2
	return row_pos_y
	
