extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var slide_collision: CollisionShape2D = $slideCollision

const SPEED = 100.0
const JUMP_VELOCITY = -300.0

var isSliding = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_pressed("ui_down"):
		_set_slope_slide(true)
	else:
		_set_slope_slide(false)

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
		
	_set_animation(direction)

	move_and_slide()
	
	$Skeleton2D.look_at(global_position)

func _set_slope_slide(boolean: bool):
	isSliding = boolean
	
	if boolean:
		slide_collision.shape.slide_on_slope = true
		floor_max_angle = deg_to_rad(15)
	else:
		slide_collision.shape.slide_on_slope = false
		floor_max_angle = deg_to_rad(45)

func _set_animation(direction):
	if direction < 0: animated_sprite_2d.flip_h = true
	elif direction > 0: animated_sprite_2d.flip_h = false

	if isSliding:
		animated_sprite_2d.play("down")
	elif velocity: animated_sprite_2d.play("move")
	else: animated_sprite_2d.play("idle")
	
	
	
	
	
