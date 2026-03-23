@tool
extends Node3D

@export var width := 5:
	set(value):
		width = value
		if Engine.is_editor_hint():
			_refresh()

@export var height := 5:
	set(value):
		height = value
		if Engine.is_editor_hint():
			_refresh()

const GRID_CELL = preload("uid://dvsgclfdqnwhw")

func _ready() -> void:
	_refresh()

func _refresh():
	_remove_grid()
	_create_grid()
	_trim_and_adjust_grid()

func _remove_grid():
	for node in get_children():
		node.queue_free()

func _create_grid():
	var gridCellNode = GRID_CELL.instantiate()
	
	for z in range(height):
		for x in range(width):
			var gridCell = gridCellNode.duplicate()

			add_child(gridCell)
			
			gridCell.global_position = global_position + Vector3(x, 0, z)

func _trim_and_adjust_grid():	
	for child in get_children():
		var collision = _get_collision_point(child.global_position)

		if collision:
			child.global_position.y = collision.position.y +0.0001
		else:
			child.hide()

func _get_collision_point(startPosition):
	var params := PhysicsRayQueryParameters3D.new()
	
	params.from = startPosition
	params.to = startPosition + Vector3(0,-100,0)
	params.collide_with_areas = true
    params.collision_mask = 1
	
	var worldspace := get_world_3d().direct_space_state
	var intersect := worldspace.intersect_ray(params)
	
	return intersect
	
	
	
	
