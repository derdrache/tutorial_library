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

const GRID_CELL = preload("uid://b7s7ojrxgpp6b")

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
	
func show_possible_movement(currentPosition, movement):
	var allMovementOptions = _get_possible_movements(currentPosition, movement)
	
	for cell in allMovementOptions:
		cell.highlight_movement()

func _get_possible_movements(currentPosition, movement):
	var currentCell = _get_cell(currentPosition)
	var neighbors = [currentCell]
	var allMovementOptions = []
		
	for i in movement:
		var allNeighbors = []
		
		for neighbor in neighbors:
			allNeighbors += _get_neighbors(neighbor)
		
			allMovementOptions += allNeighbors
		
		neighbors = allNeighbors
	
	allMovementOptions = allMovementOptions.filter(func(element): return element != currentCell)
	
	return allMovementOptions

func _get_cell(targetPosition):
	for cell in get_children():
		if cell.position_in_rect(targetPosition):
			return cell

func _get_neighbors(cell, withHeightCheck = true):
	var neighbors = [
		_get_cell(cell.global_position + Vector3.RIGHT),
		_get_cell(cell.global_position + Vector3.LEFT),
		_get_cell(cell.global_position + Vector3.FORWARD),
		_get_cell(cell.global_position + Vector3.BACK),
	]
	
	neighbors = neighbors.filter(func(element): 
		if element == null:
			return	
	
		var heightCheck = (element.global_position.y >= cell.global_position.y - 1 
			and element.global_position.y <= cell.global_position.y + 1)
		
		if withHeightCheck:
			return heightCheck
		)
	
	return neighbors

func remove_highlight():
	for cell in get_children():
		cell.reset()
	
func get_move_sequence(startPosition, targetPosition):
	var startCell = _get_cell(startPosition)
	var targetCell = _get_cell(targetPosition)
	var possibleCells = _get_all_highlighted_cells()

	possibleCells.append(startCell)
	
	var aStar = AStar3D.new()
	
	## set points
	for cell in possibleCells:
		var id = aStar.get_available_point_id()
		aStar.add_point(id, cell.global_position)
	
	## set connections
	for cell in possibleCells:
		var currentCellId = possibleCells.find(cell)
		var neighbors = _get_neighbors(cell)
		
		for neighbor in neighbors:
			var neighborId = possibleCells.find(neighbor)
			if neighborId >= 0:
				aStar.connect_points(currentCellId, possibleCells.find(neighbor), true)
	
	return aStar.get_point_path(possibleCells.find(startCell), possibleCells.find(targetCell))
	
func _get_all_highlighted_cells():
	var selectedCells = []
	
	for child in get_children():
		if child.isHighlighted:
			selectedCells.append(child)

	return selectedCells
