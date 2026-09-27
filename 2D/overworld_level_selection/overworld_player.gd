extends CharacterBody2D

const TILE_SIZE = 16

var movementOptions = []
var onMovement = false
var canSelectInput = false

func _ready() -> void:
	add_to_group("player")
	
	movementOptions = _get_movement_options()

func _get_movement_options():
	match _get_tile_atlas_cords(global_position):
		Vector2i(2,5), Vector2i(2,7): 
			return [Vector2.LEFT, Vector2.RIGHT]
		Vector2i(1,7), Vector2i(1,5): 
			return [Vector2.LEFT, Vector2.RIGHT, Vector2.DOWN]
		Vector2i(3,7), Vector2i(3,5): 
			return [Vector2.LEFT, Vector2.RIGHT, Vector2.UP]
		Vector2i(1,6), Vector2i(3,6):
			return [Vector2.UP, Vector2.DOWN]
		Vector2i(4,6): 
			return [Vector2.DOWN, Vector2.RIGHT]
		Vector2i(4,7):
			return [Vector2.UP, Vector2.RIGHT]
		Vector2i(6,6):
			return [Vector2.DOWN, Vector2.LEFT]
		Vector2i(6,7):
			return [Vector2.UP, Vector2.LEFT]
			
func _get_tile_atlas_cords(searchPosition):
	var floorLayer: TileMapLayer = get_tree().get_first_node_in_group("floorLayer")
	var tilePosition = floorLayer.local_to_map(searchPosition)
	var floorAtlasCoords = floorLayer.get_cell_atlas_coords(tilePosition)
	return floorAtlasCoords

func _input(_event: InputEvent) -> void:
	if not canSelectInput or onMovement:
		return
	
	var direction = Vector2.ZERO
	
	if Input.is_action_just_pressed("ui_left"):
		direction.x = -1
	elif Input.is_action_just_pressed("ui_right"):
		direction.x = 1
	elif Input.is_action_just_pressed("ui_up"):
		direction.y = -1
	elif Input.is_action_just_pressed("ui_down"):
		direction.y = 1
	
	if direction:
		canSelectInput = false
		_move(direction)

func _move(direction):
	var targetPosition = global_position + direction * 16
	
	var tween = create_tween()
	tween.tween_property(self, "global_position", targetPosition, 0.3)
	await tween.finished
	
	movementOptions = _get_movement_options()

	if canSelectInput:
		onMovement = false
	else:
		movementOptions.erase(-direction)
		
		_move(movementOptions[0])
