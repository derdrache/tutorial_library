extends Area3D

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var selection_mesh: MeshInstance3D = $SelectionMesh

var selectionStartPoint: Vector3

func _ready() -> void:
	selection_mesh.hide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and selectionStartPoint:
		_set_selection_collision(event.position)
		_show_selection()
		
	if Input.is_action_just_pressed("left_mouse_click"):
		_start_selection(event.position)
	elif Input.is_action_just_released("left_mouse_click"):
		_end_selection()

func _set_selection_collision(mousePosition):
	var mousePosition3D = _get_3d_mouse_position(mousePosition)
	collision_shape_3d.global_position = (selectionStartPoint + mousePosition3D) / 2
	
	collision_shape_3d.shape.size.x = abs(selectionStartPoint.x - mousePosition3D.x)
	collision_shape_3d.shape.size.z = abs(selectionStartPoint.z - mousePosition3D.z)

func _show_selection():
	selection_mesh.show()
	
	selection_mesh.global_position = collision_shape_3d.global_position
	selection_mesh.mesh.size = collision_shape_3d.shape.size
	selection_mesh.mesh.size.y = 0.01

func _start_selection(mousePosition):
	selectionStartPoint = _get_3d_mouse_position(mousePosition)

func _get_3d_mouse_position(mousePosition2D):
	var currentCamera = get_viewport().get_camera_3d()
	var params = PhysicsRayQueryParameters3D.new()
	
	params.from = currentCamera.project_ray_origin(mousePosition2D)
	params.to = currentCamera.project_position(mousePosition2D, 1000)

	var worldspace = get_world_3d().direct_space_state
	var result = worldspace.intersect_ray(params)

	if result:
		return result.position

func _end_selection():
	_select_units()
	
	selectionStartPoint = Vector3.ZERO
	
	selection_mesh.hide()

func _select_units():
	await get_tree().create_timer(0.05).timeout
	
	for body in get_tree().get_nodes_in_group("player"):
		body.set_selection(body in get_overlapping_bodies())
	
	for body in get_overlapping_bodies():
		if body.is_in_group("player"):
			body.set_selection(true)
