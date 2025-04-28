extends Node2D

@onready var grid: GridContainer = $Grid

const OBJECT = preload("res://object.tscn")

var gridSize: Vector2
var object
var targetCell
var objectCells
var isValid = false

func _ready() -> void:
	gridSize = Vector2(grid.cellWidth,grid.cellHeight)
	
func _input(event: InputEvent) -> void:
	# showcase only
	if Input.is_action_just_pressed("leftClick") and not object:
		var newPlacement = OBJECT.instantiate()
		add_child(newPlacement)
		newPlacement.global_position = get_global_mouse_position()
		object = newPlacement
	elif Input.is_action_just_pressed("leftClick") and isValid:
		_place_placement(objectCells)

func _on_grid_gui_input(event: InputEvent) -> void:
	if not object: return
	
	var mousePosition = get_global_mouse_position()
	var newTargetCell = _get_target_cell(mousePosition)
	
	if newTargetCell and newTargetCell != targetCell:
		targetCell = newTargetCell
		object.global_position = targetCell.global_position + object.rect.size/2
		
		_reset_highlight()
		objectCells = _get_object_cells()
		isValid = _check_and_hightlight_cells(objectCells)

func _get_target_cell(targetPosition):
	for child:Control in grid.get_children():
		if child.get_global_rect().has_point(targetPosition):
			return child

func _reset_highlight():
	for child:Control in grid.get_children():
		child.change_color(Color(0.5,0.5,0.5,0.5))

func _get_object_cells() -> Array:
	var cells = []

	for child:Control in grid.get_children():
		if child.get_global_rect().intersects(object.get_global_rect()):
			cells.append(child)
			
	return cells

func _check_and_hightlight_cells(objectCells: Array):
	var isValid = true
	var objectCellCount = (object.rect.size.x / gridSize.x) * (object.rect.size.y / gridSize.y)
	
	if objectCellCount != objectCells.size(): 
		isValid = false
	
	for cell in objectCells:
		if cell.full: 
			isValid = false
			cell.change_color(Color.RED)
		else:
			cell.change_color(Color.GREEN)
	
	return isValid

func _place_placement(objectCells):
	object.set_on_place()
	object = null
	isValid = null
	
	for cell in objectCells:
		cell.full = true
	
	_reset_highlight()
