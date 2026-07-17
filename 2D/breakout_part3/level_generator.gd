@tool
extends Node2D

@export var refreshStones := false:
	set(value):
		_refresh_stones()

const STONE = preload("uid://cju21g00pnput")

@export var width := 12
@export var height := 8
@export var startPosition := Vector2(200, 100)
@export var stoneSize := Vector2(70, 20)
@export var distanceBetween := Vector2(10, 5)
@export var color := Color.RED

func _ready() -> void:
    # for the case the panel color switch back to default on game start
	for child in get_children():
		child.set_new_color(color)

func _refresh_stones():
	_delete_old()
	
	_create_level()

func _delete_old():
	for child in get_children():
		child.queue_free()

func _create_level():
	for x in range(width):
		for y in range(height):
			var stoneNode = STONE.instantiate()
			stoneNode.set_new_color(color)
			stoneNode.set_size(stoneSize)
			add_child(stoneNode)
			
			var xPosition = startPosition.x + x * (stoneSize.x + distanceBetween.x)
			var yPosition = startPosition.y + y * (stoneSize.y + distanceBetween.y)
			stoneNode.global_position = Vector2(xPosition, yPosition)
			stoneNode.owner = get_tree().edited_scene_root 

func get_stone_count():
	return get_child_count()
