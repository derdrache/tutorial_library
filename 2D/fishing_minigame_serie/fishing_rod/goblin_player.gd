extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var tile_marker = $AnimatedSprite2D/tileMarker

const SPEED = 100.0

var startFishing = false
var waitForFish = false

func _physics_process(delta):
	if startFishing: _fishing_state()
	else: _move_state()

	move_and_slide()

func _fishing_state():
	velocity = Vector2.ZERO
	
	if Input.is_action_just_pressed("ui_accept"):
		_stop_fishing()
	
	if waitForFish: print("waiting for fish (next episode)")

func _move_state():
	if Input.is_action_just_pressed("ui_accept"):
		_start_fishing()
		return
	
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")

	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)	
	
	if velocity.x < 0: animated_sprite_2d.scale.x = -1
	elif velocity.x >0: animated_sprite_2d.scale.x = 1
	
	if velocity: animated_sprite_2d.play("run")
	else: animated_sprite_2d.play("idle")

func _start_fishing():
	if not _get_tile_data() == "water": return
	
	startFishing = true
	animated_sprite_2d.play("fishing_start")

func _stop_fishing():
	waitForFish = false
	animated_sprite_2d.play("fishing_end")
	
func _get_tile_data():
	var tileMap = get_parent().find_child("TileMap")
	var searchPosition = tileMap.local_to_map(tile_marker.global_position)
	var data = tileMap.get_cell_tile_data(0, searchPosition)
	
	if data: return data.get_custom_data("type")


func _on_animated_sprite_2d_animation_finished():
	if animated_sprite_2d.animation == "fishing_start":
		waitForFish = true
	elif animated_sprite_2d.animation == "fishing_end":
		startFishing = false
