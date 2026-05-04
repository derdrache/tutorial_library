extends Node3D

const TOWER = preload("uid://bn80h7myeimtq")

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_mouse_click"):
		_set_tower(event.position)

func _set_tower(mousePosition2D):
	var towerNode = TOWER.instantiate()
	get_tree().current_scene.add_child(towerNode)
	towerNode.global_position = _get_3d_mouse_position(mousePosition2D)
	towerNode.add_tower_connections()

func _get_3d_mouse_position(mousePosition2D):
	var currentCamera = get_viewport().get_camera_3d()
	var params = PhysicsRayQueryParameters3D.new()
	
	params.from = currentCamera.project_ray_origin(mousePosition2D)
	params.to = currentCamera.project_position(mousePosition2D, 1000)

	var worldspace = get_world_3d().direct_space_state
	var result = worldspace.intersect_ray(params)

	if result:
		return result.position
