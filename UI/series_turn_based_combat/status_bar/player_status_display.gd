extends Control

@onready var player_container: VBoxContainer = %playerContainer

const PLAYER_STATS_CONTAINER = preload("res://player_stats_container.tscn")

var playerList: Array

func _ready() -> void:
	playerList = get_tree().get_nodes_in_group("player")

	_reset_player_container()
	
	_set_player_agents()
	
func _reset_player_container() -> void:
	for node in player_container.get_children():
		node.queue_free()

func _set_player_agents() -> void:
	for player in playerList:
		var playerStatDisplay = PLAYER_STATS_CONTAINER.instantiate()
		player_container.add_child(playerStatDisplay)
		playerStatDisplay.set_player_stats(player.character_resource)
		
		player.player_turn_started.connect(_on_player_turn_started.bind(player))

func _on_player_turn_started(player: TurnBasedAgent) -> void:
	_deactivate_all_player_focus()
	_activate_player(player)
	
func _deactivate_all_player_focus() -> void:
	for node in player_container.get_children():
		node.deactivate_focus()
		
func _activate_player(player: TurnBasedAgent) -> void:
	var index = playerList.find(player)
	
	player_container.get_children()[index].activate_focus()
