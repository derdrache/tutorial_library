extends Area2D

signal area_changed(areaShape: CollisionShape2D)

func _ready() -> void:
	add_to_group("camera_area")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		area_changed.emit($CollisionShape2D)
