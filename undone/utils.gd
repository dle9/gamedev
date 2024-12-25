extends Node


func fade(node, prop, dest, dur) -> void:
	var tween = create_tween()
	tween.tween_property(node, prop, dest, dur)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_IN_OUT)
