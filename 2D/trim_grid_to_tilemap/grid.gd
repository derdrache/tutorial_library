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

@export var floorLayer: TileMapLayer

const GRID_CELL = preload("uid://dvcmfjsg4b0nr")

const borderSize = 4

var selectedCharacter: CharacterBody2D
var moveSelection = false

func _unhandled_input(event: InputEvent) -> void:
	var isLeftClicked = event is InputEventMouseButton and event.button_index == 1 and event.is_pressed()
	
	if isLeftClicked: _on_left_click()

func _on_left_click():
	if moveSelection: 
		var selectedNode = _get_cell(get_global_mouse_position())
		if selectedNode and selectedNode.isSelectable:
			_move_char(selectedNode)
			moveSelection = false
			_deselect_all()
		
func _move_char(targetNode):
	var targetPosition = targetNode.get_center_position()
	var positionSequence = _get_movement_sequence(targetPosition)
	
	await selectedCharacter.move_to(positionSequence)
	
	_deselect_all()
	
	var selectedNode = _get_cell(selectedCharacter.global_position)
	
	selectedNode.highlight_cell()
	
func _get_movement_sequence(targetPosition) -> Array:
	var aStar := AStarGrid2D.new()
	aStar.region = Rect2(0,0, width, height)
	aStar.cell_size = Vector2i(cellWidth + borderSize, cellHeight + borderSize)
	aStar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	aStar.update()

	for cell in _get_blocked_cells():
		var blockedPosition = _get_grid_position(cell.global_position)
		aStar.set_point_solid(blockedPosition)

	return aStar.get_id_path(
		_get_grid_position(selectedCharacter.global_position), 
		_get_grid_position(targetPosition)
		)

func _get_grid_position(targetPosition):
	var index = _get_cell(targetPosition).get_index()
	
	var x = index % width
	var y = int(index / width) 
	
	return Vector2(x, y)

func _ready() -> void:
	add_to_group("grid")
	
	if not Engine.is_editor_hint(): _add_signals()
	
	_remove_grid()
	_create_grid()
	
	_trim_grid()

func _add_signals():
	await get_tree().current_scene.ready
	
	for character in get_tree().get_nodes_in_group("player"):
		character.character_selected.connect(_on_character_selected.bind(character))

	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.enemy_selected.connect(_on_enemy_selected)
		
func _create_grid():
	columns = width
	
	for i in width * height:
		var gridCellNode = GRID_CELL.instantiate()
		gridCellNode.custom_minimum_size = Vector2(cellWidth, cellHeight)
		add_child(gridCellNode.duplicate())

func _remove_grid():
	for node in get_children():
		node.queue_free()

func _trim_grid():
	await get_tree().create_timer(0.1).timeout
	var floorTileMap:TileMapLayer = get_tree().get_first_node_in_group("floorTileMap")
	
	for gridCell in get_children():
		var gridCellPos = floorTileMap.local_to_map(gridCell.global_position)
		var floorCellSourceId = floorTileMap.get_cell_source_id(gridCellPos)
		var floorCellAtlasCoord = floorTileMap.get_cell_atlas_coords(gridCellPos)
		
		var isFloor = floorCellSourceId == 7
		var isStair = floorCellSourceId == 8 and floorCellAtlasCoord.y == 7
		
		if not isFloor and not isStair:
			gridCell.disable()

func _on_character_selected(_movement, character):
	selectedCharacter = character 
		
	var selectedNode = _get_cell(selectedCharacter.global_position)
	
	selectedNode.highlight_cell()

func _show_move_options(movement):
	_deselect_all()
	
	moveSelection = not moveSelection
	
	if not moveSelection: return

	var selectedNode = _get_cell(selectedCharacter.global_position)
	
	selectedNode.highlight_cell()
	
	_select_possible_movement(movement)

func _deselect_all():
	for node in get_children():
		node.deselect_cell()

func _select_possible_movement(movement):
	var selectedNode = _get_cell(selectedCharacter.global_position)
	var x = cellWidth + borderSize
	var y = cellHeight + borderSize
	var directions = [
		Vector2(x,0),
		Vector2(-x,0),
		Vector2(0,y),
		Vector2(0,-y)
	]
	
	var selectNodes = []
	var checkNodes = [selectedNode]
	
	for i in movement:
		var newCheckNodes = []
		
		for checkNode in checkNodes:
			for direction in directions:
				var nextNode = _get_cell(checkNode.get_center_position() + direction)
				
				if nextNode in _get_blocked_cells(): continue
				
				if nextNode and not nextNode in checkNodes and nextNode != selectedNode: 
					newCheckNodes.append(nextNode)
					selectNodes.append(nextNode)
		
		checkNodes = newCheckNodes
	
	for node in selectNodes:
		node.select_cell()
		
func _get_cell(targetPosition):
	for node in get_children():
		if node.get_global_rect().has_point(targetPosition): return node

func _get_blocked_cells():
	var blockedCells = []
	var characters = get_tree().get_nodes_in_group("character")

	for character in characters:
		blockedCells.append(_get_cell(character.global_position))

	return blockedCells
	
func _on_option_menu_move_selected():
	_show_move_options(selectedCharacter.movement)

func _on_option_menu_attack_selected():
	_mark_enemies()

func _mark_enemies():
	for enemy in get_tree().get_nodes_in_group("enemy"):
		var inDistance = _get_attack_range(enemy.global_position) <= selectedCharacter.attackRange
		
		if inDistance:
			enemy.set_marker(true)

func _get_attack_range(targetPosition):
	var aStar := AStarGrid2D.new()
	aStar.region = Rect2(0,0, width, height)
	aStar.cell_size = Vector2i(cellWidth + borderSize, cellHeight + borderSize)
	aStar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	aStar.update()
	
	var path = aStar.get_id_path(
		_get_grid_position(selectedCharacter.global_position), 
		_get_grid_position(targetPosition)
		)
	
	return path.size() - 1


func _on_enemy_selected(selectedEnemy):
	var optionMenu = get_tree().get_first_node_in_group("option_menu")
	optionMenu.hide()
	
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.set_marker(false)
		
	var startPosition = selectedCharacter.global_position
		
	var tween = create_tween()
	tween.tween_property(selectedCharacter, "global_position", selectedEnemy.global_position, 0.5)
	tween.tween_property(selectedCharacter, "global_position", startPosition, 0.5)

func _set_blocked_cell():
	for cell in get_children():
		var mapCords = floorLayer.local_to_map(cell.global_position)
		var tileData = floorLayer.get_cell_tile_data(mapCords)
		
		if tileData and tileData.get_custom_data("blocked"):
			cell.blocked = true


		
