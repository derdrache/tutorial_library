extends Node

@export var commandMenu: Control

var currentTurnOrder = []

func _ready() -> void:
	_set_order()

	_start_next_character()
	
	_set_signals()

func _set_order():
	var players = get_tree().get_nodes_in_group("player")
	var enemies = get_tree().get_nodes_in_group("enemy")
	
	currentTurnOrder = players + enemies

func _start_next_character():
	if currentTurnOrder.is_empty(): return
	
	var nextCharacter = currentTurnOrder.pop_front()
	
	if nextCharacter.is_in_group("player"):
		commandMenu.show()

	nextCharacter.set_active(true)

func _set_signals():
	var players = get_tree().get_nodes_in_group("player")
	var enemies = get_tree().get_nodes_in_group("enemy")
	
	for character in players + enemies:
		character.turn_done.connect(_on_character_turn_done)
		character.died.connect(_on_character_died)


func _on_character_turn_done():
	if currentTurnOrder.is_empty():
		_set_order()
		
	_start_next_character()

func _on_character_died(character: Node3D):
	currentTurnOrder.erase(character)
