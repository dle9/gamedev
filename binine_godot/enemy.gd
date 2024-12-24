extends CharacterBody2D


var motion = Vector2()
var speed = 50
var hit_key = null
var word_bar = null
@onready var label = $TextBox/MarginContainer/HBoxContainer/Label


func _ready() -> void:
	word_bar = Globals.generate_word_bar()
	add_to_group("enemies")
	
	
func _physics_process(delta: float) -> void:
	label.text = word_bar
	
	var Player = get_node("/root/world/player")
	
	var direction = 1
	if Player.position.x - position.x < 0:
		direction = -1
		
	position.x += direction * speed * delta
	
	if hit_key: # passed by bullet
		handle_hit(hit_key)
		hit_key = null
	
	move_and_collide(motion)
	
	
func handle_hit(hit_key) -> void:
	if word_bar.length() == 1:
		if hit_key.to_lower() == word_bar:
			queue_free()
		else:
			if word_bar.length() < 9 and Globals.is_lvl_3:
				word_bar += Globals.generate_random_letter()
	elif hit_key.to_lower() == word_bar[0]:
			word_bar = word_bar.substr(1, -1)
	else:
		if word_bar.length() < 9 and Globals.is_lvl_3:
			word_bar += Globals.generate_random_letter()
