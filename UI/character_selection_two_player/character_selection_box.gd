extends TextureRect
class_name CharacterSelectionBox

@export var selectable = true
@export var character: Character_Resource_Fighting

@onready var p_1: TextureRect = $P1
@onready var p_2: TextureRect = $P2

enum Player {NONE, PLAYER1, PLAYER2}

var selected = false

func _ready() -> void:
	p_1.hide()
	p_2.hide()

func set_player_selection(player: Player):
	if player == Player.PLAYER1:
		selected = true
		p_1.show()
	elif player == Player.PLAYER2:
		selected = true
		p_2.show()

func get_character():
	return character

func reset():
	selected = false
	
	p_1.hide()
	p_2.hide()
	
	
		
