extends Node3D

@export var enable := false:
	set(value):
		enable = value
		%Camera3D.current = value

@export var camera_sens = 0.003
@export var cameraLimitDeg = 40

@onready var spring_arm_3d: SpringArm3D = $SpringArm3D
@onready var aim_sprite: Sprite3D = %aimSprite


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	aim_sprite.hide()

func _input(event):
	if event.is_action_pressed("ui_cancel"): get_tree().quit()
	
	_camera_control(event)

func _camera_control(event):
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * camera_sens
		
		rotation.x -= event.relative.y * camera_sens
		var limitRadians = deg_to_rad(cameraLimitDeg)
		rotation.x = clampf(rotation.x, -limitRadians, limitRadians)
	
func set_aim_mode(boolean: bool):
	if boolean:
		spring_arm_3d.spring_length = 1
		aim_sprite.show()
	else:
		spring_arm_3d.spring_length = 7
		aim_sprite.hide()
