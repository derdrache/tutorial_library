extends Area3D

@export var minFloorWidth = 3
@export var minFloorHeight = 3
@export var maxFloorWidth = 15
@export var maxFloorHeight = 10
@export var maxOverlapFloors = 5

@onready var floor_map: GridMap = $floorMap
@onready var wall_map: GridMap = $wallMap

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

func create_room():
	_clear_room()
	
	var floors = _get_new_floor()
	
	_draw_floor(floors)

	_create_wall_outline()

func _has_floor(lookPosition):
	return Vector3i(lookPosition) in floor_map.get_used_cells()

func _clear_room():
	floor_map.clear()
	wall_map.clear()

func _get_new_floor() -> Array:
	var floors = []
	
	var floorCount = randi_range(2, maxOverlapFloors)
	for _floor in floorCount:
		floors.append(_create_floor())
		
	return floors
	
func _create_floor():
	var startPointRange = 3
	var starPoint = Vector2(
		randi_range(-startPointRange, startPointRange), 
		randi_range(-startPointRange, startPointRange))
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

	
	


func _on_button_pressed() -> void:
	print("test")
	create_room()
