extends CharacterBody2D

@export var tileMap : TileMap

@onready var animated_sprite_2d = $AnimatedSprite2D

const SPEED = 100.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = Vector2.ZERO

func _physics_process(delta):
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	
	if direction: velocity = direction * SPEED
	else: velocity = Vector2.ZERO
	
	if "stair" in get_tile_name():
		if direction.x > 0: velocity.y += SPEED / 1.3
		elif direction.x < 0: velocity.y -= SPEED / 1.3

	_setAnimation()
	
	move_and_slide()

func _setAnimation():
	if direction.x > 0: animated_sprite_2d.flip_h = true
	elif direction.x < 0: animated_sprite_2d.flip_h = false
	
	if velocity != Vector2.ZERO: animated_sprite_2d.play("run")
	else: animated_sprite_2d.play("idle")

func get_tile_name():
	var searchPosition = global_position
	var playerOffSet = Vector2(0,10)
	searchPosition += playerOffSet
	
	var tilePos = tileMap.local_to_map(searchPosition)
	var tileData = tileMap.get_cell_tile_data(1, tilePos)
	
	if tileData:
		var tileName = tileData.get_custom_data("tileName")
		return tileName
	else: return ""
