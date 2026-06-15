extends CharacterBody3D

func _ready() -> void:
	add_to_group("moveable_object")
	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()
