extends StaticBody3D
class_name DoorLock

signal code_accepted()

@export var validCode = 1234

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var sub_viewport: SubViewport = $SubViewport

var selected = false

func _ready() -> void:
	input_event.connect(_on_input_event)

func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	var mouse3D = mesh_instance_3d.global_transform.affine_inverse() * event_position
	var calculate2DPosition = Vector2(mouse3D.x, mouse3D.z)

	var planeSize = mesh_instance_3d.mesh.size
	calculate2DPosition += planeSize / 2
	calculate2DPosition /= planeSize
	
	var mouse2D = calculate2DPosition * Vector2(sub_viewport.size)
	
	event.position = mouse2D

	sub_viewport.push_input(event)

func _on_ui_code_entered(code: int) -> void:
	if code == validCode:
		code_accepted.emit()

func set_select(boolean: bool):
	selected = boolean
	
	if boolean:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
