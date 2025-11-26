extends CharacterBody3D

const SPEED = 2.0

var bobber: Node3D

func _ready() -> void:
	add_to_group("fish")
	
	bobber = get_tree().get_first_node_in_group("bobber")
	
	
func _physics_process(_delta: float) -> void:
	var targetPosition = bobber.fish_position_marker.global_position
	var direction = global_position.direction_to(targetPosition)
	
	look_at(targetPosition, Vector3.UP, true)
	
	if direction:
		velocity = direction * SPEED
	else:
		velocity = Vector3.ZERO
		
	move_and_slide()

	if global_position.distance_to(targetPosition) < 0.1:
		_bite_bobber()
		
func _bite_bobber():
	set_physics_process(false)
	
	var randomCount = randi_range(2,5)

	for i in randomCount:
		await get_tree().create_timer(randf_range(0.5, 1.5)).timeout
		await bobber.shake()
		
	await get_tree().create_timer(randf_range(0.5, 1.5)).timeout
	
	reparent(bobber.fish_position_marker)
	global_position = bobber.fish_position_marker.global_position
	look_at(bobber.global_position, Vector3.UP, true)
	
	bobber.bite(self)
