extends Node3D

@onready var grid: Node3D = $Grid

const FORGE = preload("res://prepeare/place_object_on_grid_done/forge.tscn")
const TOWER = preload("res://prepeare/place_object_on_grid_done/tower.tscn")

var object
var isValid = false
var objectCells

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_mouse_click") and not object:
		var buildings = [FORGE, TOWER]
		var newPlacement = buildings.pick_random().instantiate()
		add_child(newPlacement)
		object = newPlacement
	elif Input.is_action_just_pressed("left_mouse_click") and isValid:
		_place_placement(objectCells)

func _process(delta: float) -> void:
	if not object: return
	
	var mouseGridPosition = _get_grid_position()
	if mouseGridPosition:
		object.global_position = mouseGridPosition
		
		_reset_highlight()
		objectCells = _get_object_cells()
		isValid = _check_and_hightlight_cells(objectCells)

func _get_grid_position():
	var mousePositionDepth = 100
	var mousePosition := get_viewport().get_mouse_position()
	var currentCamera := get_viewport().get_camera_3d()
	var params := PhysicsRayQueryParameters3D.new()
	
	params.from = currentCamera.project_ray_origin(mousePosition)
	params.to = currentCamera.project_position(mousePosition, mousePositionDepth)
	params.collide_with_bodies = false
	params.collide_with_areas = true
	
	var worldspace := get_world_3d().direct_space_state
	var intersect := worldspace.intersect_ray(params)

	if not intersect: return
	
	if intersect.collider.get_parent().name == "Grid":
		return intersect.collider.global_position
	else:
		return 

func _reset_highlight():
	for child in grid.get_children():
		child.change_color(grid.defaultColor)

func _get_object_cells():
	var cells = []

	for child in grid.get_children():
		if child.get_rect().intersects(object.get_rect()):
			cells.append(child)
	
	return cells
	
func _check_and_hightlight_cells(objectCells: Array):
	var isValid = true

	var objectCellCount = (object.get_rect().size.x / grid.cellSize.x) * (object.get_rect().size.y / grid.cellSize.y)

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
	object = null
	isValid = null
	
	for cell in objectCells:
		cell.full = true
	
	_reset_highlight()
	
