extends Node

@onready var body: CharacterBody3D = get_parent().get_parent()

const SPEED = 1.0

var directions = [Vector3.RIGHT, Vector3.BACK, Vector3.LEFT, Vector3.FORWARD]

func do():
	if Engine.get_physics_frames() % 45 == 0:
		body.velocity = directions.pick_random() * SPEED
	
	body.look_at(body.global_position + body.velocity)
