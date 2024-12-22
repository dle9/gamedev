extends CharacterBody2D


var speed = 333.0
var key = null


func _ready() -> void:
	collision_layer = 2
	collision_mask = 1


func _physics_process(delta: float) -> void:
	var move = move_and_collide(velocity.normalized() * delta * speed)
	if is_offscreen():
		queue_free()
		print(key)


func is_offscreen() -> bool:
	var screen_size = get_viewport().size
	if position.x < 0 or position.x > screen_size.x or position.y < 0 or position.y > screen_size.y:
		return true
	return false
