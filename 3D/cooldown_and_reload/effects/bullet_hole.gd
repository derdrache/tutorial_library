extends Node3D

@export var despawnTime := 3.0 

func _ready() -> void:
	get_tree().create_timer(despawnTime).timeout.connect(queue_free)
