extends CharacterBody3D

@onready var camera_3d = $Camera3D
@onready var sprite_3d: Sprite3D = $Sprite3D
@onready var grid_map: GridMap = $"../GridMap"

const WALL_PREVIEW = preload("res://wall_preview.tscn")

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const CAMERA_SENS = 0.003

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var tile_dict = {
	"wall" : 0
}
var grid_map_orientation = {
	0: 0,
	90: 16
}
var buildingNode: Node3D
var buildingRotation = 0

func _ready():
	add_to_group("player")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event):
	if event.is_action_pressed("ui_cancel"): get_tree().quit()
	
	if Input.is_action_just_pressed("actionQ") and not buildingNode:
		_create_building_preview()
	elif Input.is_action_just_pressed("actionQ") and buildingNode:
		_set_building()
	elif Input.is_action_just_pressed("actionR") and buildingNode:
		_rotate_building()

	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * CAMERA_SENS
		rotation.x -= event.relative.y * CAMERA_SENS
		rotation.x = clamp(rotation.x, -0.5, 1.2)

func _create_building_preview():
	buildingNode = WALL_PREVIEW.instantiate()
	get_tree().current_scene.add_child(buildingNode)

func _set_building():
	var buildingPosition = grid_map.local_to_map(sprite_3d.global_position)
	var canBuild = grid_map.get_cell_item(buildingPosition) == -1
	
	if canBuild:
		grid_map.set_cell_item(buildingPosition, tile_dict["wall"], grid_map_orientation[buildingRotation])
		buildingNode.queue_free()
		buildingRotation = 0

func _rotate_building():
	buildingRotation += 90
	
	if buildingRotation == 180:
		buildingRotation = 0
	
	buildingNode.rotation_degrees.y = buildingRotation

func _physics_process(delta):
	if buildingNode:
		buildingNode.global_position = _get_building_position()
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _get_building_position():
	var gridMapPosition = grid_map.local_to_map(sprite_3d.global_position)
	
	return grid_map.map_to_local(gridMapPosition) + grid_map.global_position
