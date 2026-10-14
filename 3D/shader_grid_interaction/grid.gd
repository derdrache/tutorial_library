@tool
extends StaticBody3D

@export var gridSize := Vector2(10,10):
	set(value):
		gridSize = value
		_refresh_grid()
@export var cellSize := Vector2(2, 2):
	set(value):
		cellSize = value
		_refresh_grid() 

@export var cellColor: Color:
	set(value):
		cellColor = value
		if is_node_ready():
			$gridMesh.material_override.set_shader_parameter("cellColor", cellColor)
@export var borderColor: Color:
	set(value):
		borderColor = value
		if is_node_ready():
			$gridMesh.material_override.set_shader_parameter("borderColor", borderColor)

@onready var grid_mesh: MeshInstance3D = $gridMesh

func _refresh_grid():		
	$gridMesh.mesh.size = gridSize * cellSize
	$gridMesh.material_override.set_shader_parameter("gridSize", gridSize)
	var fullSize = gridSize * cellSize 
	$CollisionShape3D.shape.size = Vector3(fullSize.x, 0.01, fullSize.y)

func local_to_map(localPosition):
	localPosition += global_position
	
	var locPositionVec2 = Vector2(localPosition.x, localPosition.z)
	var adjustLocalPosition = locPositionVec2 + gridSize * cellSize / 2.0

	var mapPosition = floor(adjustLocalPosition / cellSize)

	var inGrid = mapPosition.x >= 0 and mapPosition.x <= gridSize.x - 1  and mapPosition.y >= 0 and mapPosition.y <= gridSize.y - 1 
	
	if not inGrid:
		return

	return mapPosition
	
func map_to_local(mapPosition):
	var localPosition = mapPosition * cellSize	
	
	var adjustLocalPosition = localPosition - gridSize * cellSize / 2.0
	
	return Vector3(adjustLocalPosition.x, 0, adjustLocalPosition.y) + global_position
