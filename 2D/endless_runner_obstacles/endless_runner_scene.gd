extends Node2D

@export var speed = 0.1

@onready var tile_map_layer: TileMapLayer = $TileMapLayer

const EAGLE = preload("res://eagle.tscn")
const BOX = preload("res://box.tscn")

var obstacleList: Array = [EAGLE, BOX]

func _process(delta: float) -> void:
	tile_map_layer.position.x -= speed

	if tile_map_layer.position.x < -270: 
		tile_map_layer.position.x = 0
		_change_tile_map()

func _change_tile_map():
	pass
	#maybe another time

func _on_obstacle_spawn_timer_timeout() -> void:
	_spawn_obstacles()

func _spawn_obstacles():
	var obstacleNode = obstacleList.pick_random().instantiate()
	add_child(obstacleNode)
	obstacleNode.global_position = obstacleNode.get_spawn_point()
