extends CharacterBody3D

@export var grid: Node3D
@export var canMove = true

func _input(event: InputEvent) -> void:
	if not canMove or not event is InputEventKey or not event.is_pressed(): return
	
	var gridCellSize = grid.get_cell_space()
	var targetPosition = global_position
	
	if Input.is_action_just_pressed("ui_left"):
		targetPosition += Vector3.LEFT * gridCellSize
	elif Input.is_action_just_pressed("ui_right"):
		targetPosition += Vector3.RIGHT * gridCellSize
	elif Input.is_action_just_pressed("ui_up"):
		targetPosition += Vector3.FORWARD * gridCellSize
	elif Input.is_action_just_pressed("ui_down"):
		targetPosition += Vector3.BACK * gridCellSize
	
	if grid.is_on_grid(targetPosition):
		global_position = targetPosition
