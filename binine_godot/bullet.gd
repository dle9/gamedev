extends CharacterBody2D


var speed = 333.0
var key = null


func _physics_process(delta: float) -> void:
	position += velocity * delta
	move_and_collide(velocity.normalized() * delta * speed)
	if is_offscreen():
		queue_free()


func is_offscreen() -> bool:
	var screen_size = get_viewport().size
	if position.x < 0 or position.x > screen_size.x or position.y < 0 or position.y > screen_size.y:
		return true
	return false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if "enemy" in body.name:
		print("hit enemy")
		body.hit_key = key
		queue_free()
