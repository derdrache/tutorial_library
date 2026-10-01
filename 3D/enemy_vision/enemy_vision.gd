extends Area3D

signal player_detacted()

func _ready() -> void:
	get_child(0).hide()

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_detacted.emit()
		hide()
