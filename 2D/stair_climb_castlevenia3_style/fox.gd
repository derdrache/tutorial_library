extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $collision

const SPEED = 100.0

var onStairs := false
var stairDirection := 1

func _physics_process(delta: float) -> void:
	if onStairs:
		_stair_movement()
	else:
		_normal_movement(delta)

	_set_animation()
	
	move_and_slide()

func _stair_movement():
	var onFloor = "floor" in _get_tile_data(global_position + Vector2.DOWN)
	
	if onFloor:
		onStairs = false
		return
		
	var direction := Input.get_axis("ui_up", "ui_down")
	if direction > 0:
		velocity = Vector2(-stairDirection, direction) * SPEED / 2
	elif direction < 0:
		velocity = Vector2(stairDirection, direction) * SPEED / 2
	else:
		velocity = Vector2.ZERO

func _set_animation():
	if velocity.x < 0: animated_sprite_2d.flip_h = true
	elif velocity.x > 0: animated_sprite_2d.flip_h = false

	if velocity: animated_sprite_2d.play("move")
	else: animated_sprite_2d.play("idle")

func _normal_movement(delta):
	collision.disabled = false
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if Input.is_action_just_pressed("ui_up") and _is_tile_stair(global_position + Vector2.UP) and is_on_floor():
		_use_stair(Vector2.UP)
	elif Input.is_action_just_pressed("ui_down") and _is_tile_stair(global_position + Vector2.DOWN) and is_on_floor():
		_use_stair(Vector2.DOWN)

func _use_stair(upDirection: Vector2):
	onStairs = true
	collision.disabled = true
	velocity.x = 0
	
	if "stairRight" in _get_tile_data(global_position + upDirection):
		stairDirection = 1
	elif "stairLeft" in _get_tile_data(global_position + upDirection):
		stairDirection = -1
	
	global_position = _get_tile_position(global_position + upDirection)

# helper functions
func _get_tile_data(localPosition):
	var tileMap: TileMapLayer = get_tree().get_first_node_in_group("tileMap")
	var tileMapCoords = tileMap.local_to_map(localPosition)
	var data = tileMap.get_cell_tile_data(tileMapCoords)
	
	if data:
		return data.get_custom_data("typ")
	else:
		return ""

func _is_tile_stair(localPosition):
	var data = _get_tile_data(localPosition)
	
	return "stair" in data
	
func _get_tile_position(localPosition):
	var tileMap: TileMapLayer = get_tree().get_first_node_in_group("tileMap")
	var tileMapCoords = tileMap.local_to_map(localPosition)
	
	return tileMap.map_to_local(tileMapCoords)
