extends StaticBody2D
class_name Block

@export var pushable := false
@export var maxPushes := -1

@onready var ray_cast_2d: RayCast2D = $RayCast2D

var currentPushCount = 0

func _ready() -> void:
	ray_cast_2d.enabled = pushable
	
func push_block(direction):
	ray_cast_2d.target_position = direction * 16
	ray_cast_2d.force_raycast_update()
	
	if not pushable or ray_cast_2d.is_colliding() or currentPushCount == maxPushes: return
	
	_move_animation(global_position + direction * 16)
	
	currentPushCount += 1

func _move_animation(targetPosition):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", targetPosition, 0.5)
