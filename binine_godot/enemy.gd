extends CharacterBody2D


var motion = Vector2()
var base_speed = 100.0
var hit_key = null
var word_bar = null


func _ready() -> void:
	position.y = get_viewport().size.y / 2
	word_bar = Globals.generate_word_bar()
	
	
func _physics_process(delta: float) -> void:
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
	if word_bar.length() > 1:
		if hit_key.to_lower() == word_bar[0]:
			word_bar = word_bar.substr(1, -1)
			print(word_bar)
	else:
		queue_free()
