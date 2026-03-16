extends Node3D

@export var joystickSensitivity := 0.02
@export var xAxisMinLimitDegree := -60.0
@export var xAxisMaxLimitDegree := 2.0

@export var minZoom := 3.0
@export var maxZoom := 40.0
@export var zoomDelay := 10.0

@onready var spring_arm_3d: SpringArm3D = $SpringArm3D

var targetZoom

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	targetZoom = spring_arm_3d.spring_length

func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_cancel"): 
		get_tree().quit()
	
	_joystick_camera_control(delta)
	
func _joystick_camera_control(delta):
	var direction = Input.get_vector("right_stick_left", "right_stick_right", "right_stick_up", "right_stick_down")
	
	if Input.is_action_pressed("activate_camera_zoom") and direction.y < 0:
		targetZoom = spring_arm_3d.spring_length - 2
	elif Input.is_action_pressed("activate_camera_zoom") and direction.y > 0:
		targetZoom = spring_arm_3d.spring_length + 2
	else:		
		rotation.y -= direction.x * joystickSensitivity
		rotation.x -= direction.y * joystickSensitivity
		rotation.x = clampf(rotation.x, deg_to_rad(xAxisMinLimitDegree), deg_to_rad(xAxisMaxLimitDegree))
			
	targetZoom = clamp(targetZoom, minZoom, maxZoom)
	spring_arm_3d.spring_length = lerp(spring_arm_3d.spring_length, targetZoom, zoomDelay * delta)
	
	
	
	
	
