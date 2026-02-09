extends StaticBody2D

@export var windVelocity: Vector2

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.manipulatedVelocity += windVelocity

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.manipulatedVelocity -= windVelocity
