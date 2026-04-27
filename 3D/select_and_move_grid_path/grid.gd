@tool
extends Node3D

@export var width := 5:
	set(value):
		width = value
		if Engine.is_editor_hint() and is_inside_tree():
			_ready()
@export var height := 5:
	set(value):
		height = value
		if Engine.is_editor_hint() and is_inside_tree():
			_ready()
@export var margin := 0.2:
	set(value):
		margin = value
		if Engine.is_editor_hint() and is_inside_tree():
			_ready()
@export var cellSize = 2:
		set(value):
			cellSize = value
			if Engine.is_editor_hint() and is_inside_tree():
				_ready()

const GRID_CELL = preload("uid://cogm2fwfksiy8")

func _ready() -> void:
	_remove_grid()
	_create_grid()

func _remove_grid():
	for node in get_children():
		node.queue_free()

func _create_grid():
	for y in range(height):
		for x in range(width):
			var cell = GRID_CELL.instantiate()
			cell.mesh.size = Vector2(cellSize, cellSize)

			add_child(cell)
			
			cell.global_position = global_position + Vector3(
				x * (cell.mesh.size.x + margin),
				0, 
				y * (cell.mesh.size.y + margin)
				)

func get_tile_at(targetPosition):
	for child in get_children():
		var rect = Rect2(
			Vector2(child.global_position.x - cellSize / 2.0, child.global_position.z - cellSize / 2.0),
			Vector2(cellSize, cellSize)
		)
		if rect.has_point(Vector2(targetPosition.x, targetPosition.z)):
			return child

func get_neighbors(cell):
	var neighbors = [
		get_tile_at(cell.global_position + Vector3.RIGHT * cellSize),
		get_tile_at(cell.global_position + Vector3.LEFT* cellSize),
		get_tile_at(cell.global_position + Vector3.FORWARD* cellSize),
		get_tile_at(cell.global_position + Vector3.BACK* cellSize),
	]

	neighbors = neighbors.filter(func(element): return element != null)
	
	return neighbors

func reset_highlight():
	for child in get_children():
		child.change_color(Color.WHITE)
