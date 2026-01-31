extends Node3D

@export var excluded: Array[Node3D] = []

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_mouse_click"):
		var player = get_tree().get_first_node_in_group("player")
		player.targetPosition = _get_3d_mouse_position(event.position)
		
func _get_3d_mouse_position(mousePosition2D):
	var currentCamera = get_viewport().get_camera_3d()
	var params = PhysicsRayQueryParameters3D.new()
	
	params.from = currentCamera.project_ray_origin(mousePosition2D)
	params.to = currentCamera.project_position(mousePosition2D, 1000)
	params.exclude = excluded.map(func(object): return object.get_rid())

	var worldspace = get_world_3d().direct_space_state
	var result = worldspace.intersect_ray(params)

	if result:
		return result.position
