extends Area2D

signal change_layer()

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var entryPoint := Vector2.ZERO

func _ready() -> void:
	add_to_group("layer_switch")
	
func _change_layer(body):
	var changePoint : Vector2 = collision_shape_2d.shape.size / 2
	var movedDistance = entryPoint - body.global_position
	
	if abs(movedDistance.y) > changePoint.y:
		change_layer.emit()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		entryPoint = body.global_position

func _on_body_exited(body: Node2D) -> void:
		if body.is_in_group("player"):
			_change_layer(body)
