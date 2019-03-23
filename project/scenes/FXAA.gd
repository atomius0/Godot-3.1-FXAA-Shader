extends MeshInstance

func _input(event: InputEvent):
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		if event.scancode == KEY_SPACE:
			visible = not visible
