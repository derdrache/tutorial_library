@tool
extends GridContainer

@export var width := 5:
	set(value): 
		width = value
		_remove_grid()
		_create_grid()
@export var height := 5:
	set(value): 
		height = value
		_remove_grid()
		_create_grid()
@export var cellWidth := 100:
	set(value): 
		cellWidth = value
		_remove_grid()
		_create_grid()
@export var cellHeight := 100:
	set(value):
		cellHeight = value
		_remove_grid()
		_create_grid()

const GRID_CELL = preload("res://grid_cell.tscn")
const borderSize = 4

var selectedCharacter: CharacterBody2D

func _unhandled_input(event: InputEvent) -> void:
	var isLeftClicked = event is InputEventMouseButton and event.button_index == 1 and event.is_pressed()
	
	if isLeftClicked: _on_left_click()

func _on_left_click():
	var selectedNode = _get_selected_node()

	if selectedNode: 
		if selectedCharacter and selectedNode.isSelectable: _move_char(selectedNode)
	else:
		selectedCharacter = null
		_deselect_all()
		
func _move_char(targetNode):
	var targetPosition = targetNode.get_center_position()
	var positionSequence = _get_movement_sequence(targetPosition)
	
	selectedCharacter.move_to(positionSequence)
	
	selectedCharacter = null
	_deselect_all()
	
func _get_movement_sequence(targetPosition) -> Array:
	var positionSequence = []
	
	var aStar := AStarGrid2D.new()
	aStar.region = Rect2(0,0, width, height)
	aStar.cell_size = Vector2i(cellWidth + borderSize, cellHeight + borderSize)
	aStar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	aStar.update()
	
	return aStar.get_id_path(
		_get_grid_position(selectedCharacter.global_position), 
		_get_grid_position(targetPosition)
		)

func _get_grid_position(position):
	var index = _get_cell(position).get_index()
	
	var width = index % 5 
	var height = int(index / 5) 

	return Vector2(width, height)

func _ready() -> void:
	add_to_group("grid")
	
	_add_signals()
	_create_grid()

func _add_signals():
	await get_tree().current_scene.ready
	
	for char in get_tree().get_nodes_in_group("character"):
		char.character_selected.connect(_on_character_selected.bind(char))
		
func _create_grid():
	columns = width

	for i in width * height:
		var gridCellNode = GRID_CELL.instantiate()
		gridCellNode.custom_minimum_size = Vector2(cellWidth, cellHeight)
		add_child(gridCellNode.duplicate())

func _remove_grid():
	for node in get_children():
		node.queue_free()

func _on_character_selected(movement, char):
	selectedCharacter = char 
		
	_deselect_all()

	var selectedNode = _get_selected_node()
	
	selectedNode.highlight_cell()
	_select_possible_movement(movement)

func _deselect_all():
	for node in get_children():
		node.deselect_cell()

func _get_selected_node():
	for node in get_children():
		if node.get_global_rect().has_point(get_global_mouse_position()):
			return node

func _select_possible_movement(movement):
	var selectedNode = _get_selected_node()
	var width = cellWidth + borderSize
	var height = cellHeight + borderSize
	var directions = [
		Vector2(width,0),
		Vector2(-width,0),
		Vector2(0,height),
		Vector2(0,-height)
	]
	
	var selectNodes = []
	var checkNodes = [selectedNode]
	
	for i in movement:
		var newCheckNodes = []
		
		for checkNode in checkNodes:
			for direction in directions:
				var nextNode = _get_cell(checkNode.get_center_position() + direction)
				
				if nextNode and not nextNode in checkNodes and nextNode != selectedNode: 
					newCheckNodes.append(nextNode)
					selectNodes.append(nextNode)
		
		checkNodes = newCheckNodes
	
	for node in selectNodes:
		node.select_cell()
		
func _get_cell(position):
	for node in get_children():
		if node.get_global_rect().has_point(position): return node
