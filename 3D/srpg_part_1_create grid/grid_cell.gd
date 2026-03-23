extends Area3D

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

func _ready() -> void:
	collision_shape_3d.disabled = Engine.is_editor_hint()
