@tool
extends Area2D

@export var minFloorWidth = 6
@export var minFloorHeight = 6
@export var maxFloorWidth = 15
@export var maxFloorHeight = 15
@export var maxOverlapFloors = 5
@export var fillGapSize = 4

@export_group("debug")
@export var refreshRoom := false:
	set(value):
		if Engine.is_editor_hint():
			_ready()
			
@onready var floor_layer: TileMapLayer = $FloorLayer
@onready var wall_layer: TileMapLayer = $WallLayer
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D
@onready var objects: Node2D = $Objects

const CHEST = preload("res://chest.tscn")
const SLIME_ENEMY = preload("res://slime_enemy.tscn")

var directions = {
	"right": Vector2i(1,0),
	"bottom": Vector2i(0,1),
	"left": Vector2i(-1,0),
	"top": Vector2i(0,-1),
}
var floorTiles = {
	"default": Vector2(1,2),
}
var wallTiles = {
	"left": Vector2(2,5),
	"right": Vector2(0,5),
	"bottom": Vector2(1,4),
	"topLeftCorner": Vector2(0,7),
	"topRightCorner": Vector2(1,7),
	"bottomLeftCorner": Vector2(0,8),
	"bottomRightCorner": Vector2(1,8),
	"top": Vector2(1,15),
	"top2": Vector2(1,14),
	"top3": Vector2(1,13),
	"top4": Vector2(1,6),
	"topLeftCornerReverse": Vector2(2,6),
	"topRightCornerReverse": Vector2(0,6),
	"bottomLeftCornerReverse": Vector2(2,4),
	"bottomRightCornerReverse": Vector2(0,4),
}

var blockedPoints: Array= []

func _ready() -> void:
	floor_layer.clear()
	wall_layer.clear()
	
	_reset_objects()

	_create_room()

func _reset_objects():
	for node in objects.get_children():
		node.queue_free()

func _create_room():
	var floorCount = randi_range(1, maxOverlapFloors)
	var floors = []
	
	for floor in floorCount:
		floors.append(_create_floor_rect())
		
	_draw_floor(floors)
	_fill_gaps()
	_create_walls()
	_create_collision_shape()
		
func _create_floor_rect():
	var startPointRange = 5
	var starPoint = Vector2(
		randi_range(-startPointRange, startPointRange), 
		randi_range(-startPointRange, startPointRange))
	var width = randi_range(minFloorWidth, maxFloorWidth)
	var height = randi_range(minFloorHeight, maxFloorHeight)
			
	return Rect2(starPoint, Vector2(width, height))

func _draw_floor(floors):
	for floor:Rect2 in floors:
		for x in floor.size.x:
			for y in floor.size.y:
				floor_layer.set_cell(Vector2(floor.position.x + x , floor.position.y + y), 0, floorTiles["default"])

func _fill_gaps():
	var changeList = []
	
	var rect: Rect2 = floor_layer.get_used_rect()

	for x in rect.size.x:
		for y in rect.size.y:
			var position = Vector2(x + rect.position.x,y + rect.position.y)
			
			if floor_layer.get_cell_source_id(position) >= 0: continue
			
			changeList += _get_fill_points(position)
	
	for point in changeList:
		floor_layer.set_cell(point, 0, floorTiles["default"])

func _get_fill_points(position):
	var list = []
	var surrounding = floor_layer.get_surrounding_cells(position)
	
	for i in surrounding.size():
		var counterSide = wrap(i + 2, 0, 4)
		var buffersurrounding = surrounding
		
		if _has_floor(surrounding[i]): 

			if _has_floor(surrounding[counterSide]):
				list.append(position)
			else:
				var bufferList = [position]
				
				for ii in fillGapSize:
					bufferList.append(buffersurrounding[counterSide])
					buffersurrounding = floor_layer.get_surrounding_cells(buffersurrounding[counterSide])
					
					if _has_floor(buffersurrounding[counterSide]):
						list += bufferList
						break

	return list

func _has_floor(position):
	return floor_layer.get_cell_source_id(position) > -1
	
func _create_walls():
	var allFloorTiles = floor_layer.get_used_cells()
	allFloorTiles.sort_custom(func(a, b): return a.y > b.y)

	for floorPosition in allFloorTiles:
		var topEnd = not _has_floor(floorPosition + directions["top"])
		var leftEnd = not _has_floor(floorPosition + directions["left"])
		var bottomEnd = not _has_floor(floorPosition + directions["bottom"])
		var rightEnd = not _has_floor(floorPosition + directions["right"])
		
		if topEnd and leftEnd: _create_top_left_corner(floorPosition)
		elif topEnd and rightEnd: _create_top_right_corner(floorPosition)
		elif bottomEnd and leftEnd: _create_bottom_left_corner(floorPosition)
		elif bottomEnd and rightEnd: _create_bottom_right_corner(floorPosition)
		elif topEnd: _create_top_wall(floorPosition)
		elif leftEnd: _create_left_wall(floorPosition)
		elif bottomEnd: _create_bottom_wall(floorPosition)
		elif rightEnd: _create_right_wall(floorPosition)

func _create_top_left_corner(position):
	_create_top_wall(position)
	
	if _has_floor(position + directions["left"] + directions["bottom"]):
		wall_layer.set_cell(position + directions["top"] * 4 + directions["left"], 0, wallTiles["topLeftCorner"])
		wall_layer.set_cell(position + directions["top"] * 3 + directions["left"], 0, wallTiles["topLeftCornerReverse"])	
	elif _has_floor(position + directions["left"] + directions["bottom"] * 2):
		wall_layer.set_cell(position + directions["top"] * 4 + directions["left"], 0, wallTiles["topLeftCorner"])
		wall_layer.set_cell(position + directions["top"] * 3 + directions["left"], 0, wallTiles["left"])
		wall_layer.set_cell(position + directions["top"] * 2 + directions["left"], 0, wallTiles["topLeftCornerReverse"])
	elif _has_floor(position + directions["left"] + directions["bottom"] * 3):
		wall_layer.set_cell(position + directions["top"] * 4 + directions["left"], 0, wallTiles["topLeftCorner"])
		wall_layer.set_cell(position + directions["top"] * 3 + directions["left"], 0, wallTiles["left"])	
		wall_layer.set_cell(position + directions["top"] * 2 + directions["left"], 0, wallTiles["left"])
	else:
		wall_layer.set_cell(position + directions["top"] * 4 + directions["left"], 0, wallTiles["topLeftCorner"])
		wall_layer.set_cell(position + directions["top"] * 3 + directions["left"], 0, wallTiles["left"])	
		wall_layer.set_cell(position + directions["top"] * 2 + directions["left"], 0, wallTiles["left"])
		wall_layer.set_cell(position + directions["top"] + directions["left"], 0, wallTiles["left"])
		
	_create_left_wall(position)
	
func _create_top_right_corner(position):
	_create_top_wall(position)
	
	if _has_floor(position + directions["right"] + directions["bottom"]):
		wall_layer.set_cell(position + directions["top"] * 4 + directions["right"], 0, wallTiles["topRightCorner"])
		wall_layer.set_cell(position + directions["top"] * 3 + directions["right"], 0, wallTiles["topRightCornerReverse"])	
	elif _has_floor(position + directions["right"] + directions["bottom"] * 2):
		wall_layer.set_cell(position + directions["top"] * 4 + directions["right"], 0, wallTiles["topRightCorner"])
		wall_layer.set_cell(position + directions["top"] * 3 + directions["right"], 0, wallTiles["right"])
		wall_layer.set_cell(position + directions["top"] * 2 + directions["right"], 0, wallTiles["topRightCornerReverse"])
	elif _has_floor(position + directions["right"] + directions["bottom"] * 3):
		wall_layer.set_cell(position + directions["top"] * 4 + directions["right"], 0, wallTiles["topRightCorner"])
		wall_layer.set_cell(position + directions["top"] * 3 + directions["right"], 0, wallTiles["right"])	
		wall_layer.set_cell(position + directions["top"] * 2 + directions["right"], 0, wallTiles["right"])
	else:
		wall_layer.set_cell(position + directions["top"] * 4 + directions["right"], 0, wallTiles["topRightCorner"])
		wall_layer.set_cell(position + directions["top"] + directions["right"], 0, wallTiles["right"])
		wall_layer.set_cell(position + directions["top"] * 2 + directions["right"], 0, wallTiles["right"])
		wall_layer.set_cell(position + directions["top"] * 3 + directions["right"], 0, wallTiles["right"])
	
	_create_right_wall(position)
	
func _create_bottom_left_corner(position):
	wall_layer.set_cell(position + directions["bottom"] + directions["left"], 0, wallTiles["bottomLeftCorner"])
	
	_create_left_wall(position)
	_create_bottom_wall(position)

func _create_bottom_right_corner(position):
	wall_layer.set_cell(position + directions["bottom"] + directions["right"], 0, wallTiles["bottomRightCorner"])
	
	_create_right_wall(position)
	_create_bottom_wall(position)
	
func _create_left_wall(position):
	if _has_floor(position + directions["left"] + directions["bottom"] * 4): return
	
	elif _has_floor(position + directions["left"] + directions["top"]):
		wall_layer.set_cell(position + directions["left"], 0, wallTiles["bottomLeftCornerReverse"])
	else:
		wall_layer.set_cell(position + directions["left"], 0, wallTiles["left"])

func _create_bottom_wall(position):
	if _has_floor(position + directions["bottom"] + directions["left"]):
		wall_layer.set_cell(position + directions["bottom"], 0, wallTiles["bottomRightCornerReverse"])
	elif _has_floor(position + directions["bottom"] + directions["right"]):
		wall_layer.set_cell(position + directions["bottom"], 0, wallTiles["bottomLeftCornerReverse"])
	else:
		wall_layer.set_cell(position + directions["bottom"], 0, wallTiles["bottom"])

func _create_right_wall(position):	
	if _has_floor(position + directions["right"] + directions["bottom"] * 4): return
	
	elif _has_floor(position + directions["right"] + directions["top"]):
		wall_layer.set_cell(position + directions["right"], 0, wallTiles["bottomRightCornerReverse"])
	else:
		wall_layer.set_cell(position + directions["right"], 0, wallTiles["right"])

func _create_top_wall(position):
	wall_layer.set_cell(position +  directions["top"], 0, wallTiles["top"])
	wall_layer.set_cell(position + directions["top"] * 2, 0, wallTiles["top2"])
	wall_layer.set_cell(position + directions["top"] * 3, 0, wallTiles["top3"])
	
	if _has_floor(position +  directions["top"] + directions["left"]):
		wall_layer.set_cell(position +  directions["top"] * 4, 0, wallTiles["topRightCornerReverse"])
	elif _has_floor(position +  directions["top"] + directions["right"]):
		wall_layer.set_cell(position +  directions["top"] * 4, 0, wallTiles["topLeftCornerReverse"])
	else:
		wall_layer.set_cell(position +  directions["top"] * 4, 0, wallTiles["top4"])

func _create_collision_shape():
	var collisionPoints = []
	
	var usedWalls = wall_layer.get_used_cells()
	
	for wallPosition in usedWalls:
		var atlasCords = wall_layer.get_cell_atlas_coords(wallPosition)

		if atlasCords == Vector2i(0,4) or atlasCords == Vector2i(2,4) or atlasCords == Vector2i(0,6) \
		or atlasCords == Vector2i(2,6) or atlasCords == Vector2i(0,7) or atlasCords == Vector2i(1,7) \
		or atlasCords == Vector2i(0,8) or atlasCords == Vector2i(1,8):
			collisionPoints.append(wall_layer.map_to_local(wallPosition))

	var sortedPoints = get_sorted_points(collisionPoints)
	$CollisionPolygon2D.set_polygon(sortedPoints)
	
func get_sorted_points(list):
	var newList = []
	var lastPoint
	var lastDirection = "y"
	var duplicateList = list.duplicate()

	for i in list.size():
		if not lastPoint: 
			lastPoint = list[i]
			newList.append(lastPoint)
			duplicateList.erase(lastPoint)
			continue
		
		var options = []
		for point in duplicateList:
			if point == lastPoint: continue
			
			if lastDirection == "y" and lastPoint.x == point.x: options.append(point)
			elif lastDirection == "x" and lastPoint.y == point.y: options.append(point)
		
		if lastDirection == "y": lastDirection = "x"
		else: lastDirection = "y"

		var selectedPoint
		var distance = 0
		for option in options:
			if not selectedPoint:
				selectedPoint = option
				distance = lastPoint.distance_to(option)
			elif lastPoint.distance_to(option) < distance:
				selectedPoint = option
				distance = lastPoint.distance_to(option)

		lastPoint = selectedPoint
		newList.append(lastPoint)
		duplicateList.erase(lastPoint)

	return newList

func connect_with(room):
	var openDirections = directions.values()
	var selectedDirection = openDirections.pick_random()
	
	var ownConnectionPointDict = get_connection_point(-1 * selectedDirection)
	var roomConnectionPointDict = room.get_connection_point(selectedDirection)
	
	var oldPosition = global_position
	global_position -= Vector2(ownConnectionPointDict["globalPosition"] - roomConnectionPointDict["globalPosition"])

	await get_tree().create_timer(0.05).timeout

	if not get_overlapping_areas().is_empty():
		return false
	
	create_door(ownConnectionPointDict["mapPoint"], -1 * selectedDirection)
	room.create_door(roomConnectionPointDict["mapPoint"], selectedDirection)
	
	return true

func get_connection_point(direction) -> Dictionary:
	var rect = floor_layer.get_used_rect()
	var allCells = floor_layer.get_used_cells()
	
	if direction == directions["right"]:
		var x = rect.position.x + rect.size.x -1
		allCells = allCells.filter(func(element): return element.x == x)
		direction *= 2
	elif direction == directions["left"]:
		var x = rect.position.x
		allCells = allCells.filter(func(element): return element.x == x)
	elif direction == directions["bottom"]:
		var y = rect.position.y + rect.size.y -1
		allCells = allCells.filter(func(element): return element.y == y)
	elif direction == directions["top"]:
		var y = rect.position.y
		allCells = allCells.filter(func(element): return element.y == y)
		direction *= 5
	
	var selectedPoint: Vector2i = allCells.pick_random()
	
	return {
		"mapPoint": selectedPoint,
		"globalPosition": floor_layer.map_to_local(selectedPoint  + direction) + global_position
	}

func create_door(doorPoint, direction):
	if direction == directions["right"]:
		_create_right_door(doorPoint, direction)
	elif direction == directions["left"]:
		_create_left_door(doorPoint, direction)
	elif direction == directions["bottom"]:
		_create_bottom_door(doorPoint, direction)
	elif direction == directions["top"]:
		_create_top_door(doorPoint, direction)
		
	wall_layer.set_cell(doorPoint + direction, 0, Vector2(-1,-1))
	floor_layer.set_cell(doorPoint + direction, 0, floorTiles["default"])
	
	blockedPoints.append(doorPoint)
	blockedPoints.append(doorPoint + direction)
	

func _create_right_door(doorPoint, direction):
	if _has_wall(doorPoint + direction + directions["top"] *2):
		wall_layer.set_cell(doorPoint + direction + directions["top"], 0, wallTiles["topRightCornerReverse"])

	if _has_wall(doorPoint + direction + directions["bottom"] *2):
		wall_layer.set_cell(doorPoint + direction + directions["bottom"], 0, wallTiles["bottomRightCornerReverse"])
	else:
		wall_layer.set_cell(doorPoint + direction + directions["bottom"], 0, wallTiles["bottom"])

func _create_left_door(doorPoint, direction):
	if _has_wall(doorPoint + direction + directions["top"] *2):
		wall_layer.set_cell(doorPoint + direction + directions["top"], 0, wallTiles["topLeftCornerReverse"])
	
	if _has_wall(doorPoint + direction + directions["bottom"] *2):
		wall_layer.set_cell(doorPoint + direction + directions["bottom"], 0, wallTiles["bottomLeftCornerReverse"])
	else:
		wall_layer.set_cell(doorPoint + direction + directions["bottom"], 0, wallTiles["bottom"])
		
func _create_bottom_door(doorPoint, direction):
	if _has_wall(doorPoint + direction + directions["left"] *2):
		wall_layer.set_cell(doorPoint + direction + directions["left"], 0, wallTiles["bottomLeftCornerReverse"])
	else:
		wall_layer.set_cell(doorPoint + direction + directions["left"], 0, wallTiles["left"])
		
	if _has_wall(doorPoint + direction + directions["right"] *2):
		wall_layer.set_cell(doorPoint + direction + directions["right"], 0, wallTiles["bottomRightCornerReverse"])
	else:
		wall_layer.set_cell(doorPoint + direction + directions["right"], 0, wallTiles["right"])

func _create_top_door(doorPoint, direction):
	wall_layer.set_cell(doorPoint + direction*2, 0, Vector2(-1,-1))
	wall_layer.set_cell(doorPoint + direction*3, 0, Vector2(-1,-1))
	wall_layer.set_cell(doorPoint + direction*4, 0, Vector2(-1,-1))
	
	floor_layer.set_cell(doorPoint + direction * 2, 0, floorTiles["default"])
	floor_layer.set_cell(doorPoint + direction * 3, 0, floorTiles["default"])
	floor_layer.set_cell(doorPoint + direction * 4, 0, floorTiles["default"])
	
	blockedPoints.append(doorPoint + direction * 2)
	blockedPoints.append(doorPoint + direction * 3)
	blockedPoints.append(doorPoint + direction * 4)
	
	if _has_wall(doorPoint + direction * 4 + directions["left"] *2):
		wall_layer.set_cell(doorPoint + direction  * 4 + directions["left"], 0, wallTiles["topLeftCornerReverse"])
	else:
		wall_layer.set_cell(doorPoint + direction  * 4 + directions["left"], 0, wallTiles["left"])
		
	if _has_wall(doorPoint + direction * 4 + directions["right"] *2):
		wall_layer.set_cell(doorPoint + direction * 4 + directions["right"] , 0, wallTiles["topRightCornerReverse"])
	else:
		wall_layer.set_cell(doorPoint + direction  * 4 + directions["right"], 0, wallTiles["right"])

func _has_wall(lookPosition):
	return wall_layer.get_cell_source_id(lookPosition) > -1

func _get_random_floor_point():
	var floorPoints = floor_layer.get_used_cells()
	var unsedFloorPoints = floorPoints.filter(func(point): return not point in blockedPoints)
	
	var selectedPoint = unsedFloorPoints.pick_random()
	return selectedPoint

func create_chest():
	var position = _get_random_floor_point()
	blockedPoints.append(position)

	var chestNode = CHEST.instantiate()
	objects.add_child(chestNode)
	chestNode.global_position = floor_layer.map_to_local(position) + floor_layer.global_position
	
func create_enemy():
	var position = _get_random_floor_point()
	blockedPoints.append(position)

	var chestNode = SLIME_ENEMY.instantiate()
	objects.add_child(chestNode)
	chestNode.global_position = floor_layer.map_to_local(position) + floor_layer.global_position

	
	
	
	
	
	
