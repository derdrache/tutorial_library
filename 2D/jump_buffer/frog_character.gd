extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_buffer_timer: Timer = %jumpBufferTimer

const SPEED = 150.0
const JUMP_VELOCITY = -350.0

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		jump_buffer_timer.start()
		
	# Add the gravity.
	#if not is_on_floor():
	#	velocity += get_gravity() * delta

	# Handle jump.
	var onJumpBuffer = jump_buffer_timer.time_left > 0
	if (Input.is_action_just_pressed("ui_accept") or onJumpBuffer) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	_set_animation()

	move_and_slide()

func _set_animation():
	if velocity.x > 0: animated_sprite_2d.flip_h = false
	elif velocity.x < 0: animated_sprite_2d.flip_h = true
	
	if velocity:
		animated_sprite_2d.play("walk")
	else:
		animated_sprite_2d.play("idle")
