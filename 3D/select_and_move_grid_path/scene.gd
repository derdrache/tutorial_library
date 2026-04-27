extends Node3D

@onready var barbarian: CharacterBody3D = $Barbarian
@onready var grid: Node3D = $Grid

var path := []

func _ready() -> void:
	var startPosition = barbarian.global_position
	path.append(grid.get_tile_at(startPosition))

func _input(_event: InputEvent) -> void:	
	if Input.is_action_just_pressed("left_mouse_click"):
		_add_to_path(_get_3d_mouse_position())
	elif Input.is_action_just_pressed("right_mouse_click"):
		_move()

func _get_3d_mouse_position():
	var currentCamera := get_viewport().get_camera_3d()
	var groundPlane = Plane(Vector3.UP, 0)
	var mouse2D = get_viewport().get_mouse_position()
	var rayStart = currentCamera.project_ray_origin(mouse2D)
	var rayDirection = currentCamera.project_ray_normal(mouse2D)

	var mouse3D = groundPlane.intersects_ray(rayStart, rayDirection)
	return mouse3D

func _add_to_path(selectedPosition):
	var selectedCell = grid.get_tile_at(selectedPosition)
	
	if not selectedCell: return

	var canSelected = path[-1] in grid.get_neighbors(selectedCell) 

	if not canSelected: return
	
	path.append(selectedCell)
	selectedCell.change_color(Color.YELLOW)

func _move():
	path.pop_front()
	
	for cell in path:
		barbarian.look_at(cell.global_position, Vector3.UP, true)
		var tween = create_tween()
		tween.tween_property(barbarian, "global_position", cell.global_position, 0.5)
		await tween.finished
	
	path = []
	grid.reset_highlight()
