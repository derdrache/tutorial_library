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

func _ready() -> void:
	_remove_grid()
	_create_grid()

func _remove_grid():
	for node in get_children():
		node.queue_free()

func _create_grid():
	for height in range(height):
		for width in range(width):
			var mesh = MeshInstance3D.new()
			mesh.mesh = PlaneMesh.new()
			mesh.mesh.size = Vector2(cellSize, cellSize)

			add_child(mesh)
			
			mesh.global_position = global_position + Vector3(
				width * (mesh.mesh.size.x + margin),
				0, 
				height * (mesh.mesh.size.y + margin)
				)
				
			if Engine.is_editor_hint():
				mesh.owner = get_tree().edited_scene_root

func get_cell_space():
	return cellSize + margin
	
func is_on_grid(targetPosition):
	var position2D = Vector2(global_position.x - cellSize / 2, global_position.z- cellSize / 2)
	var targetposition2D = Vector2(targetPosition.x, targetPosition.z)
	var width = width * (cellSize+ margin)
	var height = height * (cellSize+ margin)
	
	var rect = Rect2(position2D, Vector2(width, height))

	return rect.has_point(targetposition2D)
