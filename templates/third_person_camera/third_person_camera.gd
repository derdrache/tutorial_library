extends Node3D

@export var enable := true:
	set(value):
		enable = value
		if not Engine.is_editor_hint():
			%Camera3D.current = value

@export var mouseSensitivity = 0.003
@export var joystickSensitivity := 0.02

@export var xAxisMinLimitDegree := -60.0
@export var xAxisMaxLimitDegree := 2.0

@export var zoomDelay = 10
@export var minZoom: float = 3.0
@export var maxZoom: float = 40.0

# This Version is without SpringArm.
# If you want to use SpringArm replace "camera_3d.position.z" with "spring_arm_3d.spring_length"
@onready var camera_3d: Camera3D = %Camera3D

var targetZoom

func _ready():
	if Engine.is_editor_hint(): return 
	
	targetZoom = camera_3d.position.z

func _input(event):
	if event.is_action_pressed("ui_cancel") and event.is_action_pressed("ui_accept"): get_tree().quit()
	
	_mouse_camera_control(event)

func _mouse_camera_control(event):
	if not Input.is_action_pressed("activate_camera_movement"): return
	
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * mouseSensitivity
		
		rotation.x -= event.relative.y * mouseSensitivity
		rotation.x = clampf(rotation.x, deg_to_rad(xAxisMinLimitDegree), deg_to_rad(xAxisMaxLimitDegree))

	if Input.is_action_just_pressed("camera_zoom_in"):
		targetZoom = camera_3d.position.z - 2
	elif Input.is_action_just_pressed("camera_zoom_out"):
		targetZoom = camera_3d.position.z + 2

	targetZoom = clamp(targetZoom, minZoom, maxZoom)

func _process(delta: float) -> void:
	camera_3d.position.z = lerp(camera_3d.position.z, targetZoom, zoomDelay * delta)
	
	var hasgamePad = Input.get_connected_joypads().size() > 0
	if hasgamePad:
		_joystick_camera_control()
	
		
func _joystick_camera_control():
	var direction = Input.get_vector("camera_left", "camera_right", "camera_zoom_in", "camera_zoom_out")
	
	if Input.is_action_pressed("activate_camera_movement") and direction.y < 0:
		targetZoom = camera_3d.position.z - 2
	elif Input.is_action_pressed("activate_camera_movement") and direction.y > 0:
		targetZoom = camera_3d.position.z + 2
	else:		
		rotation.y -= direction.x * joystickSensitivity
		rotation.x -= direction.y * joystickSensitivity
		rotation.x = clampf(rotation.x, deg_to_rad(xAxisMinLimitDegree), deg_to_rad(xAxisMaxLimitDegree))
	
	targetZoom = clamp(targetZoom, minZoom, maxZoom)
	
