extends StaticBody3D

@onready var selection_mesh: MeshInstance3D = %selectionMesh

func _ready() -> void:
	selection_mesh.hide()

func set_selection(boolean: bool):
	selection_mesh.visible = boolean
