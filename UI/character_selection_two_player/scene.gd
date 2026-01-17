extends Control

@onready var grid_container: GridContainer = $HBoxContainer/allCharacters/GridContainer

@onready var player_1: TextureRect = $HBoxContainer/Player1
@onready var player_2: TextureRect = $HBoxContainer/Player2

var player1SelectionIndex: int = 1
var player2SelectionIndex: int = 2

var player1Character: Character_Resource_Fighting
var player2Character: Character_Resource_Fighting

func _ready() -> void:
	_refresh_selection()

func _refresh_selection():
	for child in grid_container.get_children():
		child.reset()

	var startContainerP1 = grid_container.get_child(player1SelectionIndex)
	var startContainerP2 = grid_container.get_child(player2SelectionIndex)
	
	startContainerP1.set_player_selection(CharacterSelectionBox.Player.PLAYER1)
	player_1.texture = startContainerP1.get_character().texture
	
	startContainerP2.set_player_selection(CharacterSelectionBox.Player.PLAYER2)
	player_2.texture =  startContainerP2.get_character().texture

func _input(event: InputEvent) -> void:
	if not event.is_pressed(): return
	
	var player1Direction = Input.get_vector("keyboard_left", "keyboard_right", "keyboard_up", "keyboard_down")
	var player2Direction = Input.get_vector("joypad_left", "joypad_right", "joypad_up", "joypad_down", 1).round()
	
	if not player1Character:
		player1SelectionIndex = _get_selection_index(player1SelectionIndex, player1Direction)
	
	if not player2Character:
		player2SelectionIndex = _get_selection_index(player2SelectionIndex, player2Direction)
	
	_refresh_selection()
	
	if Input.is_action_just_pressed("ui_accept"):
		player1Character = grid_container.get_child(player1SelectionIndex).get_character()
	if Input.is_action_just_pressed("joypad_accept"):
		player2Character = grid_container.get_child(player2SelectionIndex).get_character()

func _get_selection_index(currentIndex: int, direction: Vector2i):
	var index: int = currentIndex
	
	if direction.x:
		index = currentIndex + direction.x
	
	if direction.y:
		index = currentIndex + direction.y * grid_container.columns
	
	var selectedContainer = grid_container.get_child(index)
	if selectedContainer and selectedContainer.selectable and not selectedContainer.selected:
		return index
	else:
		return currentIndex

func _selection_done():
	if player1Character and player2SelectionIndex:
		pass
		# save selections in a global script
		# change scene
