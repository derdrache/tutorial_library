extends CharacterBody2D

signal enemy_selected(enemy)

func _ready() -> void:
	add_to_group("character")
	add_to_group("enemy")


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	var onLeftClicked :bool = event is InputEventMouseButton and event.button_index == 1 and event.is_pressed()
	if onLeftClicked: enemy_selected.emit(self)

func set_marker(boolean:bool):
	if boolean:
		$AnimatedSprite2D.modulate = Color(1.0, 0.0, 0.0, 1.0)
	else:
		$AnimatedSprite2D.modulate = Color(1.0, 1.0, 1.0, 1.0)
		
	input_pickable = boolean
