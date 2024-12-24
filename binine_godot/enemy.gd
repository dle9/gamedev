extends CharacterBody2D


var motion = Vector2()
var base_speed = 650.0
var hit_key = null
var word_bar = null
@onready var label = $TextBox/MarginContainer/HBoxContainer/Label


func _ready() -> void:
	position.y = get_viewport().size.y / 2
	word_bar = Globals.generate_word_bar()
	
	
func _physics_process(delta: float) -> void:
	label.text = word_bar
	
	var Player = get_parent().get_node("player")
	
	var direction = 1
	if Player.position.x - position.x < 0:
		direction = -1
		
	position.x += direction * base_speed * delta
	
	if hit_key:
		handle_hit(hit_key)
		hit_key = null
	
	move_and_collide(motion)
	
	
func handle_hit(hit_key) -> void:
	if word_bar.length() == 1:
		if hit_key.to_lower() == word_bar:
			queue_free()
		else:
			if word_bar.length() < 9:
				word_bar += Globals.generate_random_letter()
	elif hit_key.to_lower() == word_bar[0]:
			word_bar = word_bar.substr(1, -1)
	else:
		if word_bar.length() < 9:
			word_bar += Globals.generate_random_letter()
