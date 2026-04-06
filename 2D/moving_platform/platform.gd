extends Path2D

@export var speed := 0.2

@onready var path_follow_2d: PathFollow2D = $PathFollow2D

var forwardDirection = 1

func _physics_process(delta: float) -> void:
	path_follow_2d.progress_ratio += speed * delta * forwardDirection
	
	if forwardDirection == 1 and path_follow_2d.progress_ratio == 1:
		forwardDirection = -1
	elif forwardDirection == -1 and path_follow_2d.progress_ratio == 0: 
		forwardDirection = 1
