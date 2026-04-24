extends Area2D

@export var connectedPortal: Node2D

var disable := false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not disable:
		connectedPortal.disable = true
		body.global_position = connectedPortal.global_position

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		disable = false
