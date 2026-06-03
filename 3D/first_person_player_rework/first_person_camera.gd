extends Camera3D

@export var CAMERA_SENS = 0.003

func _ready() -> void:
	# hide mouse
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event.is_action_pressed("ui_cancel"): 
		get_tree().quit()
	
	if event is InputEventMouseMotion:
		# left and right rotation
		rotation.y -= event.relative.x * CAMERA_SENS
		
		# up and down rotation
		rotation.x -= event.relative.y * CAMERA_SENS
		
		# limit up and down rotation
		var maxDownDegree = -60
		var maxUpDegree = 80
		rotation.x = clamp(rotation.x, deg_to_rad(maxDownDegree), deg_to_rad(maxUpDegree))
