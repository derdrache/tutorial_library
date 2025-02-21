extends Node2D

@export var onFastTravel = false
@export var spawnPoint: Node2D
@export var fastTravelSpawnPoint : Node2D

const FOX_PLAYER_MAP = preload("res://tutorial_collection/Map_Fast_Travel/fox_player_Map.tscn")

func _ready() -> void:
	var player = FOX_PLAYER_MAP.instantiate()
	add_child(player)

	if onFastTravel: player.global_position = fastTravelSpawnPoint.global_position
	else: player.global_position = spawnPoint.global_position
