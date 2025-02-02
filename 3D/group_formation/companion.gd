extends CharacterBody3D

@export var companionNumber := 1

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

const SPEED = 5.0

func _physics_process(delta: float) -> void:
	var groupFormation = get_tree().get_first_node_in_group("GroupFormation")
	var targetPosition: Vector3 = groupFormation.get_formation_position(companionNumber)
		
	navigation_agent_3d.set_target_position(targetPosition)
	
	var nextPathPosition = navigation_agent_3d.get_next_path_position()
	
	var direction = global_position.direction_to(nextPathPosition)
	var calculateVelcotiy = direction * SPEED
	velocity = Vector3(calculateVelcotiy.x, velocity.y, calculateVelcotiy.z)
	
	_refresh_rotation()

	move_and_slide()

func _refresh_rotation():
	var player = get_tree().get_first_node_in_group("player")
	transform.basis = player.get_transform_basis()
