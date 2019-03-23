extends MeshInstance

func _process(delta : float) -> void:
	rotation += Vector3(0.0, 1.0, 0.0) * delta
