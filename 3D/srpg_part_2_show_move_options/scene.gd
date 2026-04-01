extends Node3D

@onready var grid: Node3D = $Grid

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_mouse_click"):
		var collisionObject = _get_collision_object(event.position)

		if not collisionObject:
			return
			
		var isPlayerCharacter = collisionObject in get_tree().get_nodes_in_group("player_character")
		
		if isPlayerCharacter:
			grid.remove_highlight()
			_highlight_movement_options(collisionObject)

func _get_collision_object(mousePosition):
	var currentCamera := get_viewport().get_camera_3d()
	var params := PhysicsRayQueryParameters3D.new()

	params.from = currentCamera.project_ray_origin(mousePosition)
	params.to = currentCamera.project_position(mousePosition, 400)
	params.collide_with_areas = true
	
	var worldspace := get_world_3d().direct_space_state
	var intersect := worldspace.intersect_ray(params)
	
	if intersect:
		return intersect.collider

func _highlight_movement_options(character):
	var currentPosition = character.global_position
	var movement = character.movement
	
	grid.show_possible_movement(currentPosition, movement)
