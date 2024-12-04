extends Area3D
class_name Collectable

@export var isCollected := false

const SPEED = 1


func _physics_process(delta: float) -> void:
	if not isCollected: return
	
	var playerPosition = get_tree().get_first_node_in_group("player").global_position
	var direction: Vector3 = (playerPosition - global_position).normalized()

	global_position += direction * SPEED * delta
	
	if global_position.distance_to(playerPosition) < 0.1: queue_free()
