extends Node3D

@export var objects: Array[PackedScene]
@export var spawnPoints: Array[Marker3D]

func _on_timer_timeout() -> void:
	var randomObject = objects.pick_random()
	var randomSpawnPoint = spawnPoints.pick_random()
	
	var objectNode = randomObject.instantiate()
	get_tree().current_scene.add_child(objectNode)
	objectNode.global_position = randomSpawnPoint.global_position
