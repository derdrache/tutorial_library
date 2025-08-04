extends Node3D

@export var cameraSens = 0.004
@export var cameraSpeed = 1.0
@export var maxZoom = 40
@export var minZoom = 8

@onready var camera_3d: Camera3D = $Camera3D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event.is_action_pressed("ui_cancel"): get_tree().quit()

	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * cameraSens

	_camera_zoom()

func _camera_zoom():
	var zoomChange = 0
	if Input.is_action_pressed("mouse_wheel_up"):
		zoomChange -= 1
	elif Input.is_action_pressed("mouse_wheel_down"):
		zoomChange += 1
	
	camera_3d.size += zoomChange
	camera_3d.size = clamp(camera_3d.size, minZoom, maxZoom)

func _physics_process(delta: float) -> void:
	_camera_movement()

func _camera_movement():
	var direction = Vector2.ZERO
	direction.y = Input.get_axis("ui_up", "ui_down")
	direction.x = Input.get_axis("ui_left", "ui_right")
	
	global_position += (global_basis * Vector3(direction.x, 0, direction.y)).normalized() * cameraSpeed
