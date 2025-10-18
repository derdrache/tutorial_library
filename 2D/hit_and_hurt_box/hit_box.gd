extends Area2D
class_name HitBox

func _ready() -> void:
	set_active(false)

func set_active(boolean: bool):
	for child in get_children():
		if child is not CollisionShape2D: continue
		
		child.disabled = not boolean

func _on_area_entered(area: Area2D) -> void:
	if area is HurtBox:
		area.get_damage(1)
