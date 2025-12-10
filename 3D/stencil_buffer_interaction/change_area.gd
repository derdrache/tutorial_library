extends Area3D

@export var targetMask : int

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.change_collision_mask(targetMask)
