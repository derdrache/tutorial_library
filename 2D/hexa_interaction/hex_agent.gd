extends Node2D

@export var tileMap : TileMapLayer
@export var offSet = Vector2(0, -6)

var isMoving = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("leftClick"):
		_move()
		
func _move():
	if isMoving: return
	
	var mousePosition = get_global_mouse_position()
	var isTargetPositionValid = get_tile_global_position(mousePosition)
	
	if not isTargetPositionValid: return

	isMoving = true
	
	var movementArray = _get_route(mousePosition)

	for movement in movementArray:
		var playerTilePosition = tileMap.local_to_map(global_position)
		var targetTilePosition = playerTilePosition + movement
		var targetPosition = tileMap.map_to_local(targetTilePosition) + offSet
		
		var tween := create_tween()
		tween.tween_property(get_parent(), "global_position", targetPosition, 0.3)
		
		await tween.finished
	
	isMoving = false
	
func get_tile_global_position(mousePosition):
	var mouseTilePosition := tileMap.local_to_map(mousePosition)
	var mouseTileData = tileMap.get_cell_atlas_coords(mouseTilePosition)

	if mouseTileData == Vector2i(-1, -1): return
	
	var tileGlobalPosition = tileMap.map_to_local(mouseTilePosition)
	
	return Vector2i(tileGlobalPosition)

func _get_route(targetPosition):
	var routeArray = []
	
	var direction = tileMap.local_to_map(targetPosition) - tileMap.local_to_map(global_position)
	var currentTilePosition = tileMap.local_to_map(global_position)

	while direction:
		var newPoint = snap(direction, 1)

		# forbid running directly up or down
		# forbid (1,1) and (-1,-1)
		if newPoint.x and newPoint.y and newPoint.x == newPoint.y:
			var checkPoint = Vector2i(0, newPoint.y)
			
			if not _has_tile(currentTilePosition + checkPoint):
				newPoint.y = 0
			else:
				newPoint.x = 0
		
		#handle border
		if not _has_tile(currentTilePosition + newPoint):
			var points = [Vector2i(0,newPoint.y), Vector2i(newPoint.x, 0)]
			
			for point in points:
				if point == Vector2i.ZERO: continue
				
				if _has_tile(currentTilePosition + point):
					newPoint = point
				
		routeArray.append(newPoint)
		direction -= newPoint
		currentTilePosition += newPoint
	
	return routeArray
	
func snap(vector, step: int):
	if vector.x > 0: vector.x = 1
	elif vector.x < 0: vector.x = -1
	
	if vector.y > 0: vector.y = 1
	elif vector.y < 0: vector.y = -1
	
	return vector
	
func _has_tile(tilePosition):
	var tileData = tileMap.get_cell_atlas_coords(tilePosition)
	return tileData != Vector2i(-1, -1)
