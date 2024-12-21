extends Node2D

@export var speed = 0.1

@onready var tile_map_layer: TileMapLayer = $TileMapLayer

func _process(delta: float) -> void:
	tile_map_layer.position.x -= speed

	if tile_map_layer.position.x < -270: 
		tile_map_layer.position.x = 0
		_change_tile_map()

func _change_tile_map():
	pass
	#maybe another time
