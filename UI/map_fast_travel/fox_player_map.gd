extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var map: CanvasLayer = $Map

const SPEED = 100.0
const JUMP_VELOCITY = -250.0

var is_map_open = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interaction"):
		if not is_map_open: _open_map()
		else: _close_map()
			
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _open_map():
	is_map_open = true
	get_tree().paused = true
	set_physics_process(false)
	
	animated_sprite_2d.play("open_map")
	await animated_sprite_2d.animation_finished
	map.show()
	
func _close_map():
	is_map_open = false
	get_tree().paused = false
	map.hide()
	
	animated_sprite_2d.play_backwards("open_map")
	
	await animated_sprite_2d.animation_finished
	
	set_physics_process(true)
