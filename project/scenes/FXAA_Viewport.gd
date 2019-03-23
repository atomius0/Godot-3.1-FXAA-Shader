extends ViewportContainer

func _ready() -> void:
	get_tree().connect("screen_resized", self, "_on_screen_resized")
	_on_screen_resized()


func _on_screen_resized() -> void:
	#get_surface_material(0).set_shader_param("resolution", OS.window_size)
	#print(get_surface_material(0).get_shader_param("resolution"))
	material.set_shader_param("resolution", OS.window_size)
	print(material.get_shader_param("resolution"))
