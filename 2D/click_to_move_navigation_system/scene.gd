extends Node3D

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_mouse_click"):
		var player = get_tree().get_first_node_in_group("player")
		player.set_target_position(_get_3d_mouse_position(event.position))
		
func _get_3d_mouse_position(mousePosition2D):
	var currentCamera = get_viewport().get_camera_3d()
	var params = PhysicsRayQueryParameters3D.new()
	
	params.from = currentCamera.project_ray_origin(mousePosition2D)
	params.to = currentCamera.project_position(mousePosition2D, 1000)

	var worldspace = get_world_3d().direct_space_state
	var result = worldspace.intersect_ray(params)

	if result:
		return result.position
