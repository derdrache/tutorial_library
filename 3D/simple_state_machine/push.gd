extends Node

@onready var body: CharacterBody3D = get_parent().get_parent()

func do():
	var direction = body.target.global_position.direction_to(body.global_position)
	direction.y = 0
	body.target.global_position += direction * -5
	
	body.currentState = body.States.FOLLOW
