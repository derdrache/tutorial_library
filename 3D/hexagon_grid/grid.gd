@tool
extends Node3D

# 1.0 tile size + 0.05 border size
@export var tileSize = 1.05:
	set(value):
		tileSize = value
		_refresh()
@export var widthRows := 4:
	set(value):
		widthRows = value
		_refresh()
@export var heightRows := 4:
	set(value):
		heightRows = value
		_refresh()

const HEXAGON_TILE = preload("uid://byc03e5g1pel5")

func _refresh():
	_delete_old()
	
	_set_tiles()

func _delete_old():
	for child in get_children():
		child.queue_free()

func _set_tiles():
	for widthRow in widthRows:
		for heightRow in heightRows:
			var tileNode = HEXAGON_TILE.instantiate()
			
			add_child(tileNode)
			
			var xPos = widthRow * tileSize / 1.25
			var zPos = heightRow * tileSize
			
			var isOdd = widthRow % 2 != 0
			if isOdd:
				zPos += tileSize / 2
				
			tileNode.global_position = Vector3(xPos, 0, zPos)
