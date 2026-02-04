extends HBoxContainer

signal unitSelected(unitResource: unit_resource)

func _ready() -> void:
	for child in get_children():
		child.pressed.connect(_on_unit_box_pressed)

func _on_unit_box_pressed(unitResource: unit_resource):
	unitSelected.emit(unitResource)
