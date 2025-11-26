extends StaticBody3D

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

const FISH = preload("uid://5brn2cut7n8o")

func start_fish_event():
	var fishNode = FISH.instantiate()
	
	add_child(fishNode)
	
	var spawnPoint = _get_random_point()
	fishNode.global_position = spawnPoint
	
func _get_random_point():
	var boxSize = collision_shape_3d.shape.size / 2
	var randomPoint = Vector3(randf_range(-boxSize.x, boxSize.x), -3, randf_range(-boxSize.z, boxSize.z))

	return global_position + randomPoint
