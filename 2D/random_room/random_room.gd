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

func _ready() -> void:
	return
	floor_layer.clear()
	wall_layer.clear()

	_create_room()

func _create_room():
	var floorCount = randi_range(1, maxOverlapFloors)
	var floors = []
	
	for floor in floorCount:
		floors.append(_create_floor_rect())
		
	_draw_floor(floors)
	_fill_gaps()
	_create_walls()
		
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
			
			var surrounding = floor_layer.get_surrounding_cells(position)
			
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


		
		
		
