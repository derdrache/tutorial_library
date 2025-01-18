extends Node
class_name TurnBasedController

var characterTurnOrder: Array[TurnBasedAgent] = []
var activeCharacter: TurnBasedAgent

func _ready() -> void:
	add_to_group("turnBasedController")
	
	_set_after_all_ready()
	
func _set_after_all_ready():
	await get_tree().create_timer(0.1).timeout
	
	_set_late_signals()
	_set_turn_order()
	_set_next_active_character()

func _set_late_signals():
	for player: TurnBasedAgent in get_tree().get_nodes_in_group("turnBasedAgents"):
		player.turn_finished.connect(_on_turn_done)
		
func _on_turn_done():
	_set_next_active_character()

func _set_turn_order():
	var players = get_tree().get_nodes_in_group("player")
	var enemies = get_tree().get_nodes_in_group("enemy")
	
	for node in players + enemies:
		characterTurnOrder.append(node)	

func _set_next_active_character():
	if activeCharacter: 
		characterTurnOrder.pop_front()
	
	if characterTurnOrder.is_empty():
		_set_turn_order()
		
	activeCharacter = characterTurnOrder[0]
	activeCharacter.set_active(true)
