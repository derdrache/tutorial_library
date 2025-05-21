extends RigidBody3D

@onready var label_3d: Label3D = $Label3D

var selected = false

func _ready() -> void:
	add_to_group("object")
	
	label_3d.hide()
	label_3d.top_level = true
	
func set_selection(boolean: bool):
	selected = boolean
	
func _process(delta: float) -> void:
	label_3d.global_position = global_position + Vector3(0,0.75,0)
