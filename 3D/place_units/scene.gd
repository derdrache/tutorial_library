extends Node3D

var selectedUnit: Node3D

func _input(_event: InputEvent) -> void:
	if selectedUnit and Input.is_action_just_pressed("left_mouse_click"):
		selectedUnit = null

func _process(_delta: float) -> void:
	if selectedUnit:
		selectedUnit.global_position = _get_3d_mouse_position()

func _get_3d_mouse_position():
	var mousePosition = get_viewport().get_mouse_position()
	var currentCamera := get_viewport().get_camera_3d()
	var params := PhysicsRayQueryParameters3D.new()
	var mousePositionDepth = 1000

	params.from = currentCamera.project_ray_origin(mousePosition)
	params.to = currentCamera.project_position(mousePosition, mousePositionDepth)
	params.exclude = [selectedUnit]

	var worldspace := get_world_3d().direct_space_state
	var intersect := worldspace.intersect_ray(params)

	if intersect: 
		return intersect.position
	else:
		return Vector3.ZERO

func _on_unit_selection_unit_selected(unitResource: unit_resource) -> void:
	if selectedUnit:
		selectedUnit.queue_free()
		
	selectedUnit = unitResource.model.instantiate()
	add_child(selectedUnit)
