extends TextureRect

var super_sampling_amount := 2.0

onready var viewport_node = get_node("../" + texture.viewport_path)

func _ready() -> void:
	get_tree().connect("screen_resized", self, "_on_screen_resized")
	_on_screen_resized()
	#print("vppath: ", texture.viewport_path)


func _on_screen_resized() -> void:
	#viewport_node = get_node("/" + texture.viewport_path)
	if not viewport_node:
		return
	
	var new_size: Vector2 = OS.window_size
	print("new_size = ", new_size)
	
	rect_position.y = new_size.y
	rect_size = new_size
	viewport_node.size = new_size * super_sampling_amount
	print("viewport_node.size = ", viewport_node.size)
