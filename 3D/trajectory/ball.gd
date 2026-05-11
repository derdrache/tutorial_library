extends CharacterBody3D

var speed = 8

var start = false

func throw(direction):
	velocity = direction * speed

func _physics_process(delta: float) -> void:
	if not velocity or is_on_floor():
		return
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()
