extends Area3D

@export var minFloorWidth = 3
@export var minFloorHeight = 3
@export var maxFloorWidth = 15
@export var maxFloorHeight = 10
@export var maxOverlapFloors = 5

@onready var floor_map: GridMap = $floorMap
@onready var wall_map: GridMap = $wallMap
@onready var collision_polygon_3d: CollisionPolygon3D = $CollisionPolygon3D
@onready var environment: Node3D = $environment
@onready var minimap_marker: Node3D = %minimapMarker
@onready var minimap_floor: CSGPolygon3D = %minimapFloor


const ENEMY = preload("res://enemy.tscn")

var tiles = {
	"floor": 0,
	"normalWall": 0,
	"cornerWall": 1,
	"doorWay": 2,
	"normalWallOffSet": 3
}

var directions = {
	"right": Vector3i.RIGHT,
	"bottom": Vector3i.BACK,
	"left": Vector3i.LEFT,
	"top": Vector3i.FORWARD,
}

var blockedPoints: Array = []

func _ready() -> void:
	create_room()

func create_room():
	_clear_room()
	
	var floors = _get_new_floor()
	
	_draw_floor(floors)

	_create_wall_outline()
	
	_create_collision_shape()
	
	_create_minimap_floor()

func _create_collision_shape():
	var collisionPoints = []
	
	var usedWalls = wall_map.get_used_cells()

	for wallPosition in usedWalls:
		var wallNumber = wall_map.get_cell_item(wallPosition)
		
		if wallNumber == tiles["cornerWall"]:
			var wallGlobalPosition = wall_map.map_to_local(wallPosition)			
			collisionPoints.append(Vector2(wallGlobalPosition.x, wallGlobalPosition.z))
	
	var sortedPoints = _get_sorted_points(collisionPoints)
	
	collision_polygon_3d.set_polygon(sortedPoints)

func _get_sorted_points(list):
	var sortedList = []
	
	for i in list.size():		
		if i == 0: 
			sortedList.append(list[i])
			continue
		
		var lastPoint = sortedList[i - 1]
		var options = _get_next_move_options(list, sortedList, lastPoint)
	
		var selectedPoint = _get_nearest_point(options, lastPoint)
		
		sortedList.append(selectedPoint)
		var direction = (selectedPoint - lastPoint).normalized() * 4
	
	return sortedList

func _get_next_move_options(list, sortedList, lastPoint):
	var options = []
	
	for point in list:
		if point in sortedList: continue
		
		var direction = (point - lastPoint).normalized() * 4
		
		var lastDirection = Vector2.ZERO
		if sortedList.size() > 1: 
			lastDirection = (sortedList[-1] - sortedList[-2]).normalized() * 4
		var allowedDirection = direction != lastDirection and direction != -lastDirection

		var searchPoint = Vector3(lastPoint.x + direction.x, 0, lastPoint.y + direction.y)
		var hasDirectionWall = wall_map.get_cell_item(wall_map.local_to_map(searchPoint)) > -1
		
		var sameAxis = point.x == lastPoint.x or point.y == lastPoint.y
		
		if allowedDirection and hasDirectionWall and sameAxis:
			options.append(point)
	
	return options

func _get_nearest_point(list: Array, lastPoint):	
		if list.size() == 1:
			return list[0]
		else:
			var selectedPoint
			var shortestDistance
			
			for point in list:
				var distance = point.distance_to(lastPoint)
				
				if not selectedPoint or distance < shortestDistance: 
					shortestDistance = distance
					selectedPoint = point
			
			return selectedPoint

func _has_floor(lookPosition):
	return Vector3i(lookPosition) in floor_map.get_used_cells()

func _clear_room():
	floor_map.clear()
	wall_map.clear()
	blockedPoints.clear()

func _get_new_floor() -> Array:
	var floors = []
	
	var floorCount = randi_range(2, maxOverlapFloors)
	for _floor in floorCount:
		floors.append(_create_floor())
		
	return floors
	
func _create_floor():
	var startPointRange = 3
	var starPoint = Vector2(
		randi_range(-minFloorWidth, 0), 
		randi_range(-minFloorHeight, 0))
	var width = randi_range(minFloorWidth, maxFloorWidth)
	var height = randi_range(minFloorHeight, maxFloorHeight)
			
	return Rect2(starPoint, Vector2(width, height))

func _draw_floor(floors):
	for dungeonFloor:Rect2 in floors:
		for x in dungeonFloor.size.x:
			for z in dungeonFloor.size.y:
				var floorPosition = Vector3(dungeonFloor.position.x + x , 0, dungeonFloor.position.y + z)
				floor_map.set_cell_item(floorPosition, tiles["floor"])

func _create_wall_outline():
	var allFloorTiles = floor_map.get_used_cells()
	for floorPosition in allFloorTiles:	
		var topFloor = not _has_floor(floorPosition + directions["top"])
		var leftFloor = not _has_floor(floorPosition + directions["left"])
		var bottomFloor = not _has_floor(floorPosition + directions["bottom"])
		var rightFloor = not _has_floor(floorPosition + directions["right"])
		
		if topFloor and leftFloor: 
			wall_map.set_cell_item(floorPosition, tiles["cornerWall"], 16)
		elif topFloor and rightFloor: 
			wall_map.set_cell_item(floorPosition, tiles["cornerWall"])
		elif bottomFloor and leftFloor: 
			wall_map.set_cell_item(floorPosition, tiles["cornerWall"], 10)
		elif bottomFloor and rightFloor: 
			wall_map.set_cell_item(floorPosition, tiles["cornerWall"], 22)
		elif topFloor:
			wall_map.set_cell_item(floorPosition, tiles["normalWall"])
		elif leftFloor: 
			wall_map.set_cell_item(floorPosition, tiles["normalWall"], 16)
		elif bottomFloor: 
			wall_map.set_cell_item(floorPosition, tiles["normalWall"])
		elif rightFloor: 
			wall_map.set_cell_item(floorPosition, tiles["normalWall"], 16)
		elif not _has_floor(floorPosition + directions["top"] + directions["left"]):
			wall_map.set_cell_item(floorPosition, tiles["cornerWall"], 22)
		elif not _has_floor(floorPosition + directions["top"] + directions["right"]):
			wall_map.set_cell_item(floorPosition, tiles["cornerWall"], 10)
		elif not _has_floor(floorPosition + directions["bottom"] + directions["left"]):
			wall_map.set_cell_item(floorPosition, tiles["cornerWall"])
		elif not _has_floor(floorPosition + directions["bottom"] + directions["right"]):
			wall_map.set_cell_item(floorPosition, tiles["cornerWall"], 16)

func connect_with(room):
	var openDirections = directions.values()
	var selectedDirection = openDirections.pick_random()
	
	var ownConnectionPointDict = get_connection_point(-1 * selectedDirection)
	var roomConnectionPointDict = room.get_connection_point(selectedDirection)
	
	global_position -= Vector3(ownConnectionPointDict["globalPosition"] - roomConnectionPointDict["globalPosition"])

	await get_tree().create_timer(0.05).timeout

	if not get_overlapping_areas().is_empty():
		return false
	
	create_door(ownConnectionPointDict["mapPoint"], -1 * selectedDirection)
	room.create_door(roomConnectionPointDict["mapPoint"], selectedDirection)
	
	return true

func get_connection_point(direction) -> Dictionary:
	var rect = _get_used_rect(floor_map)
	var allCells = floor_map.get_used_cells()
		
	if direction == directions["right"]:
		var x = rect.position.x + rect.size.x -1
		allCells = allCells.filter(func(element): return element.x == x)
	elif direction == directions["left"]:
		var x = rect.position.x
		allCells = allCells.filter(func(element): return element.x == x)
	elif direction == directions["bottom"]:
		var z = rect.position.y + rect.size.y -1
		allCells = allCells.filter(func(element): return element.z == z)
	elif direction == directions["top"]:
		var z = rect.position.y
		allCells = allCells.filter(func(element): return element.z == z)
	
	allCells = allCells.filter(func(element): return wall_map.get_cell_item(element) != 1)
	
	var selectedPoint: Vector3i = allCells.pick_random()
	
	return {
		"mapPoint": selectedPoint,
		"globalPosition": floor_map.map_to_local(selectedPoint + direction) + global_position
	}

func _get_used_rect(gridMap: GridMap) -> Rect2:
	var rectPosition = Vector2.ZERO
	var rectSize = Vector2.ZERO
	
	var xList: Array = []
	var zList = []
	
	for tilePosition in gridMap.get_used_cells():
		xList.append(tilePosition.x)
		zList.append(tilePosition.z)

	rectPosition = Vector2(xList.min(), zList.min())
	rectSize = Vector2(xList.max() - rectPosition.x + 1, zList.max() - rectPosition.y + 1)

	return Rect2(rectPosition, rectSize)

func create_door(doorPoint, direction):
	blockedPoints.append(doorPoint)
	
	if direction == directions["right"]:
		blockedPoints.append(doorPoint + directions["right"])
		wall_map.set_cell_item(doorPoint, tiles["doorWay"], 16)
	elif direction == directions["left"]:
		blockedPoints.append(doorPoint + directions["left"])
		wall_map.set_cell_item(doorPoint, tiles["doorWay"], 22)
	elif direction == directions["bottom"]:
		blockedPoints.append(doorPoint + directions["bottom"])
		wall_map.set_cell_item(doorPoint, tiles["doorWay"])
	elif direction == directions["top"]:
		blockedPoints.append(doorPoint + directions["top"])
		wall_map.set_cell_item(doorPoint, tiles["doorWay"], 10)
		
	_create_minimap_door(floor_map.map_to_local(doorPoint))
	
	if direction == directions["right"]:
		floor_map.set_cell_item(doorPoint + directions["right"], tiles["floor"])
		floor_map.set_cell_item(doorPoint + directions["right"] + directions["top"], tiles["floor"])
		floor_map.set_cell_item(doorPoint + directions["right"] +  directions["bottom"], tiles["floor"])
		
		wall_map.set_cell_item(doorPoint + directions["right"] + directions["top"], tiles["normalWallOffSet"], 10)
		wall_map.set_cell_item(doorPoint + directions["right"] +  directions["bottom"], tiles["normalWallOffSet"])
		
		_create_minimap_door(floor_map.map_to_local(doorPoint + directions["right"]))
	elif direction == directions["top"]:
		floor_map.set_cell_item(doorPoint + directions["top"], 0)
		floor_map.set_cell_item(doorPoint + directions["top"] + directions["left"], tiles["floor"], 16)
		floor_map.set_cell_item(doorPoint + directions["top"] +  directions["right"], tiles["floor"], 16)
		
		wall_map.set_cell_item(doorPoint + directions["top"] + directions["left"], tiles["normalWallOffSet"], 22)
		wall_map.set_cell_item(doorPoint + directions["top"] +  directions["right"], tiles["normalWallOffSet"], 16)
		
		_create_minimap_door(floor_map.map_to_local(doorPoint + directions["top"]))

func get_random_floor_global_position():
	var randomFloorPoint = _get_random_floor_point()
	
	blockedPoints.append(randomFloorPoint)
	
	return floor_map.map_to_local(randomFloorPoint) + floor_map.global_position
	
func _get_random_floor_point():
	var unsedFloorPoints = _get_unused_floor_points()
	
	var selectedPoint = unsedFloorPoints.pick_random()
	return selectedPoint
	
func _get_unused_floor_points():
	var floorPoints = floor_map.get_used_cells()
	var wallPoints = wall_map.get_used_cells()
	var unsedFloorPoints = floorPoints.filter(func(point): return not point in blockedPoints + wallPoints)
	
	return unsedFloorPoints

func create_enemy():
	var spawnPoint = _get_random_floor_point()
	blockedPoints.append(spawnPoint)

	var enemy = ENEMY.instantiate()
	environment.add_child(enemy)
	
	enemy.global_position = floor_map.map_to_local(spawnPoint) + floor_map.global_position

func _create_minimap_floor():
	var collisionPoints = []
	
	var usedWalls = wall_map.get_used_cells()
	
	for wallPosition in usedWalls:
		var wallNumber = wall_map.get_cell_item(wallPosition)
		var cornerWallNumber = 1
		
		if wallNumber == cornerWallNumber:
			var wallGlobalPosition = wall_map.map_to_local(wallPosition)
			collisionPoints.append(Vector2(wallGlobalPosition.x, wallGlobalPosition.z))

	var sortedPoints = _get_sorted_points(collisionPoints)
	
	minimap_floor.polygon = sortedPoints
	
func _create_minimap_door(position):
	var size = Vector2(4,4)
	var mesh: MeshInstance3D = MeshInstance3D.new()
	mesh.mesh = PlaneMesh.new()
	mesh.mesh.size = size
	mesh.set_layer_mask_value(1, false)
	mesh.set_layer_mask_value(2, true)
	
	var material := StandardMaterial3D.new()
	material.albedo_color = Color.ORANGE
	
	mesh.mesh.material = material

	minimap_marker.add_child(mesh)
	
	mesh.position = position
