extends Node3D
class_name DragAndDrop3D

signal isDragging(boolean)

@export var mousePositionDepth := 100

var _draggingObject: DraggingObject

func _ready() -> void:
	_set_dragging_object_signals()
	
func _set_dragging_object_signals():
	await get_tree().current_scene.ready
	for node : DraggingObject in get_tree().get_nodes_in_group("draggingObjects"):
		node.object_body_mouse_down.connect(_select_object.bind(node))

func _select_object(object: DraggingObject):
	if not _draggingObject: 
		_draggingObject = object
		isDragging.emit(true)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if _draggingObject and event.button_index == 1 and not event.is_pressed():
			_stop_drag()
	elif event is InputEventMouseMotion:
		if _draggingObject: _handle_drag()

func _stop_drag() -> void:
	_draggingObject = null
	isDragging.emit(false)
	
func _handle_drag() -> void:
	var mousePosition3D = _get_3d_mouse_position()

	if mousePosition3D: _draggingObject.global_position = mousePosition3D
	
func _get_3d_mouse_position():
	var mousePosition = get_viewport().get_mouse_position()
	var currentCamera = get_viewport().get_camera_3d()
	var params = PhysicsRayQueryParameters3D.new()
	
	params.from = currentCamera.project_ray_origin(mousePosition)
	params.to = currentCamera.project_position(mousePosition, mousePositionDepth)
	params.exclude = [_draggingObject.get_rid()]
	
	var worldspace = get_world_3d().direct_space_state
	var intersect = worldspace.intersect_ray(params)

	if not intersect: return
	
	return intersect.position
	
	