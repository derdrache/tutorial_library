extends PanelContainer

@onready var camera_3d: Camera3D = $SubViewportContainer/SubViewport/Camera3D

func _process(delta: float) -> void:
	var playerPosition = get_tree().get_first_node_in_group("player").global_position
	playerPosition.y = camera_3d.global_position.y
	
	camera_3d.global_position = playerPosition
