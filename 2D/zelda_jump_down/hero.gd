extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 100.0

var lastDirection: Vector2
var onAction = false

func _physics_process(_delta: float) -> void:
	if onAction: 
		return
	
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	var isColliding = move_and_slide()

	if isColliding:
		var colliderPosition = get_last_slide_collision().get_position() + direction
		var tileData = _get_tile_data(colliderPosition, "type")

		if "jumpSpot" in tileData:
			_do_jump(tileData)
			return
	
	_set_animation(direction)
	
	lastDirection = direction

func _do_jump(directionText):
	onAction = true
		
	animated_sprite_2d.stop() # or your jump animation
	
	var direction = Vector2.ZERO
	directionText = directionText.split("jumpSpot")[1]
	match directionText:
		"Right": direction = Vector2.RIGHT
		"Left": direction = Vector2.LEFT
		"Up": direction = Vector2.UP
		"Down": direction = Vector2.DOWN
	
	var tween = create_tween()
	var targetPosition = global_position + (direction * (16 * 2 + 8))
	tween.tween_property(self, "global_position", targetPosition, 0.5)
	
	await tween.finished

	onAction = false

func _set_animation(direction):
	if direction.x > 0:
		animated_sprite_2d.flip_h = false
	elif direction.x < 0:
		animated_sprite_2d.flip_h = true

	if direction:
		if direction.y > 0:
			animated_sprite_2d.play("walk_down")
		elif direction.y < 0:
			animated_sprite_2d.play("walkd_up")
		elif direction.x != 0:
			animated_sprite_2d.play("walk_side")
	else:
		if lastDirection.y > 0:
			animated_sprite_2d.play("idle_down")
		elif lastDirection.y < 0:
			animated_sprite_2d.play("idle_up")
		elif lastDirection.x != 0:
			animated_sprite_2d.play("idle_side")

# helper function
func _get_tile_data(tilePosition, customDataString):
	var tileMapLayer : TileMapLayer = get_tree().get_first_node_in_group("mainTileMapLayer")
	var mapPosition = tileMapLayer.local_to_map(tilePosition)

	var tileData = tileMapLayer.get_cell_tile_data(mapPosition)
	
	if tileData:
		return tileData.get_custom_data(customDataString)
