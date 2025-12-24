extends Node3D

@export var enable := false:
	set(value):
		enable = value
		if not Engine.is_editor_hint():
			%Camera3D.current = value

@export var camera_sens = 0.003
@export var cameraLimitDeg = 40

func _input(event):
	if event.is_action_pressed("ui_cancel"): get_tree().quit()
	
	_camera_control(event)

func _camera_control(event):
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * camera_sens
		
		rotation.x -= event.relative.y * camera_sens
		var limitRadians = deg_to_rad(cameraLimitDeg)
		rotation.x = clampf(rotation.x, -limitRadians, limitRadians)
	
