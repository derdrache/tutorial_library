extends Path2D

@export var speed = 500
@export var targetPosition: Vector2

@onready var path_follow_2d = $PathFollow2D

func _ready():
	curve.set_point_out(0,Vector2(targetPosition.x / 2, - abs(targetPosition.x)))
	curve.set_point_position(1, targetPosition)
	
func _process(delta):
	if not targetPosition: return
	
	if path_follow_2d.progress_ratio >= 0.98: queue_free()
	
	path_follow_2d.progress += speed * delta
