extends LineEdit


# allow user to click out of username box
func _input(event:InputEvent):
	if (has_focus()
	and event is InputEventMouseButton
	and not get_global_rect().has_point(event.position)):
		release_focus()
