extends CharacterBody3D

@onready var selection_indicator: MeshInstance3D = %selectionIndicator

func _ready() -> void:
	add_to_group("enemy")
	
	set_selection(false)
	
func set_selection(boolean: bool):
	selection_indicator.visible = boolean
