extends Node3D

@onready var highlight_mesh: MeshInstance3D = $highlightMesh
@onready var grid: StaticBody3D = $Grid

func _on_grid_input_event(_camera: Node, _event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	var mousePosition = _get_mouse_position()
	
	if not mousePosition:
		return
	
	var mapPosition = grid.local_to_map(mousePosition)
	var highlightMesSize = Vector3(highlight_mesh.mesh.size.x, 0.0001, highlight_mesh.mesh.size.x)
	
	highlight_mesh.global_position = grid.map_to_local(mapPosition) + highlightMesSize / 2.0
	
	highlight_mesh.show()

func _get_mouse_position():
	var mousePosition := get_viewport().get_mouse_position()
	var currentCamera := get_viewport().get_camera_3d()
	var params := PhysicsRayQueryParameters3D.new()
	
	params.from = currentCamera.project_ray_origin(mousePosition)
	params.to = currentCamera.project_position(mousePosition, 1000)
	params.collide_with_areas = true
	
	var worldspace := get_world_3d().direct_space_state
	var intersect := worldspace.intersect_ray(params)

	if not intersect: return
	
	return intersect.position
