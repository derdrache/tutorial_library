extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var directions = [Vector3.RIGHT, Vector3.BACK, Vector3.LEFT, Vector3.FORWARD]

func _physics_process(delta: float) -> void:
	if Engine.get_physics_frames() % 60 == 0:
		velocity = directions.pick_random() * SPEED

	move_and_slide()
