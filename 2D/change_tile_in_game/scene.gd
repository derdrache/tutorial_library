extends Node2D

@onready var customize_layer: TileMapLayer = $customizeLayer

var tileSetNumber = 0
var grassTile = Vector2i(1,1)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mousePosition = get_global_mouse_position()
		var tilePosition = customize_layer.local_to_map(mousePosition - customize_layer.global_position)
		
		if Input.is_action_just_pressed("leftClick"):
			customize_layer.set_cell(tilePosition, tileSetNumber, grassTile)
		elif Input.is_action_just_pressed("rightClick"):
			customize_layer.set_cell(tilePosition)
