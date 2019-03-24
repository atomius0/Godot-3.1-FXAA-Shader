extends ColorRect

func _ready() -> void:
	get_tree().connect("screen_resized", self, "_on_screen_resized")
	_on_screen_resized()


# this function is required to inform the shader when the window is resized.
func _on_screen_resized() -> void:
	material.set_shader_param("resolution", OS.window_size)
	print(material.get_shader_param("resolution"))


func _input(event: InputEvent):
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		if event.scancode == KEY_SPACE: # toggle shader on and off with space
			visible = not visible
