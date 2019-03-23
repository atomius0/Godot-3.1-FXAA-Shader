extends ViewportContainer

# these two variables are only needed to toggle the shader on and off.
var shader_enabled = true
onready var fxaa_shader = material.shader

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
			enable_shader(not shader_enabled)


func enable_shader(enable: bool) -> void:
	if enable:
		material.shader = fxaa_shader
		shader_enabled = true
	else:
		material.shader = null
		shader_enabled = false
