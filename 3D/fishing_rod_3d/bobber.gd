extends CharacterBody3D

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if is_on_floor() and velocity.y <= 0:
		velocity = Vector3.ZERO

	move_and_slide()
