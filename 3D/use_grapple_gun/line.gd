extends Node3D

@onready var csg_cylinder_3d: CSGCylinder3D = $CSGCylinder3D

var targetPosition

func _ready() -> void:
	hide()

func set_target_position(newTargetPosition):
	targetPosition = newTargetPosition
	
	show()

func _process(delta: float) -> void:
	if not targetPosition: return
	
	_set_line(targetPosition)

func _set_line(newTargetPosition):
	targetPosition = newTargetPosition
	
	var length = global_position.distance_to(targetPosition)
	look_at(targetPosition)
	csg_cylinder_3d.height = length
	
	csg_cylinder_3d.global_position = (global_position + targetPosition) / 2
