extends CharacterBody2D

@onready var levelTileMap : TileMapLayer = get_node("../TileMapLayer")
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 150.0
const JUMP_VELOCITY = -310.0
const SWIM_SPEED = 125

enum STATES {WALK, SWIM}

var direction: Vector2
var state = STATES.WALK

func _physics_process(delta: float) -> void:
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if state == STATES.WALK: walk_state(delta)
	elif state == STATES.SWIM: swim_state(delta)
	
	_set_animation()

	move_and_slide()

func walk_state(delta):
	if "Water" in get_tile_data() and not velocity.y < 0: 
		state = STATES.SWIM
		
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if direction:
		velocity.x = direction.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func swim_state(_delta):
	if not "Water" in get_tile_data(): state = STATES.WALK
	
	if not "Water" in get_tile_data(global_position + Vector2(0, -8)) && Input.is_action_pressed("ui_up"):
		velocity = Vector2.ZERO
	elif direction: velocity = direction * SWIM_SPEED
	else: velocity = Vector2.ZERO

	if "WaterTop" in get_tile_data() && Input.is_action_just_pressed("ui_accept"):
		velocity.y = JUMP_VELOCITY
		state = STATES.WALK

func get_tile_data(targetPosition = global_position):
	var tilePos = levelTileMap.local_to_map(targetPosition)
	var tileData : TileData = levelTileMap.get_cell_tile_data(tilePos)
	
	if tileData:
		if tileData && tileData.get_custom_data("Type") != "": 
			return tileData.get_custom_data("Type")

	return ""

func _set_animation():
	if direction.x > 0: animated_sprite_2d.flip_h = false
	elif direction.x < 0: animated_sprite_2d.flip_h = true
	

	if state == STATES.WALK:
		_set_walk_animation()
	elif state == STATES.SWIM:
		animated_sprite_2d.play("swim")

func _set_walk_animation():
	if velocity:
		if velocity.y:
			animated_sprite_2d.play("jump")
		else:
			animated_sprite_2d.play("walk")
	else: animated_sprite_2d.play("idle")	
