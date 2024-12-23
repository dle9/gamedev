extends CharacterBody2D


var motion = Vector2()
var base_speed = 100.0


func _physics_process(delta: float) -> void:
	var Player = get_parent().get_node("player")
	
	var direction = 1
	if Player.position.x - position.x < 0:
		direction = -1
		
	position.x += direction * base_speed * delta
	move_and_collide(motion)
