extends Node

@export var speed := 4.0

@onready var body: CharacterBody3D = get_parent().get_parent()

func do():	
	var nextPathPosition = body.navigation_agent_3d.get_next_path_position()
	
	var direction = body.global_position.direction_to(nextPathPosition)
	var calculateVelcotiy = direction * speed
	calculateVelcotiy.y = 0
	
	body.velocity = calculateVelcotiy
	
	body.look_at(body.global_position + calculateVelcotiy)
	
	body.navigation_agent_3d.set_target_position(body.target.global_position)
