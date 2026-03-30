extends Node3D

@onready var spawn_points: Node3D = $spawnPoints

const APPLE = preload("uid://dqbqmx42e2nhx")

func _ready() -> void:
	_spawn_and_despawn_apples()

func _spawn_and_despawn_apples():
	for i in 10:
		await get_tree().create_timer(1).timeout
		
		var appleNode = APPLE.instantiate()
		add_child(appleNode)
		
		var randomMarker = spawn_points.get_children().pick_random()
		appleNode.global_position = randomMarker.global_position
		
		await get_tree().create_timer(1).timeout
		
		appleNode.queue_free()
