extends CharacterBody3D

@onready var bullet_marker: Marker3D = %bulletMarker

const LINE = preload("res://collection/grapple_gun/line.tscn")

var line: Node3D

func _process(delta: float) -> void:
	if line:
		line.global_position = bullet_marker.global_position

func shoot(targetPosition):
	_create_line(targetPosition)
	
func _create_line(targetPosition):
	line = LINE.instantiate()

	get_tree().current_scene.add_child(line)
	line.global_position = bullet_marker.global_position
	
	line.set_target_position(targetPosition)

func remove_line():
	line.queue_free()
	line = null
