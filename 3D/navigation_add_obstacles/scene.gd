extends Node3D

@onready var navigation_region_3d: NavigationRegion3D = $NavigationRegion3D

const OBSTACLE = preload("uid://dskgbtwcu2t6c")

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("right_mouse_click"):
		_handle_obstacle(event.position)
		
func _handle_obstacle(clickPosition):
	var mouseObject = _get_mouse_object(clickPosition)
	
	if not mouseObject: return

	var isObstacle = mouseObject.collider.is_in_group("obstacle")
	
	if isObstacle:
		mouseObject.collider.queue_free()
	else:
		var obstacleNode = OBSTACLE.instantiate()

		add_child(obstacleNode)
		obstacleNode.global_position = mouseObject.position
	
	_refresh_navigation_region()

func _get_mouse_object(mousePosition2D):
	var currentCamera = get_viewport().get_camera_3d()
	var params = PhysicsRayQueryParameters3D.new()
	
	params.from = currentCamera.project_ray_origin(mousePosition2D)
	params.to = currentCamera.project_position(mousePosition2D, 1000)

	var worldspace = get_world_3d().direct_space_state
	var result = worldspace.intersect_ray(params)

	return result

func _refresh_navigation_region():
	await get_tree().create_timer(0.01).timeout
	
	navigation_region_3d.bake_navigation_mesh()
