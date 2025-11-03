extends Camera2D

func _ready() -> void:
	_set_signals()
	
func _set_signals():
	for area in get_tree().get_nodes_in_group("camera_area"):
		area.area_changed.connect(_on_camera_area_changed)

func _on_camera_area_changed(areaShape: CollisionShape2D):
	limit_left = areaShape.global_position.x - areaShape.shape.size.x / 2
	limit_right = areaShape.global_position.x + areaShape.shape.size.x / 2
	limit_bottom = areaShape.global_position.y + areaShape.shape.size.y / 2
	limit_top = areaShape.global_position.y - areaShape.shape.size.y / 2
