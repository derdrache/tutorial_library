extends CharacterBody2D

signal character_selected

var movement = 2

func _ready() -> void:
	add_to_group("character")

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	var onLeftClicked :bool = event is InputEventMouseButton and event.button_index == 1 and event.is_pressed()
	if onLeftClicked: character_selected.emit(movement)
