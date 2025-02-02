extends Node3D

@export var camera_target: Node3D
@export var pitch_max = 20
@export var pitch_min = -10

var yaw = float()
var pitch = float()
var yaw_sensitivity = .002
var pitch_sensitivity = .002

func _ready():
	add_to_group("mainCamera")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event.is_action_pressed("ui_cancel"): get_tree().quit()
	
	if event is InputEventMouseMotion:
		yaw += -event.relative.x * yaw_sensitivity
		pitch += event.relative.y * pitch_sensitivity
		
func _physics_process(delta):
	camera_target.rotation.y = lerp(camera_target.rotation.y, yaw, delta * 10)
	camera_target.rotation.x = lerp(camera_target.rotation.x, pitch, delta * 10)
	pitch = clamp(pitch, deg_to_rad(pitch_min), deg_to_rad(pitch_max))

func get_camera_transform():
	return camera_target.transform
	
