extends CharacterBody3D

@export var active := false

func _physics_process(delta: float) -> void:
	if not active: return
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()
