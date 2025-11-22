extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var max_jump_height_timer: Timer = $maxJumpHeightTimer

const SPEED = 150.0

var JUMP_VELOCITY = -250.0

var startJumping = false

func _physics_process(delta: float) -> void:
	if not is_on_floor() and not startJumping:
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		startJumping = true
		max_jump_height_timer.start()
	elif Input.is_action_just_released("ui_accept") and startJumping:
		startJumping = false
		
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	_set_animation(direction)

	move_and_slide()
		
func _set_animation(direction):
	if direction < 0: animated_sprite_2d.flip_h = false
	elif direction > 0: animated_sprite_2d.flip_h = true
	
	if is_on_floor():
		if velocity.x != 0:
			animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("idle")
	else:
		if velocity.y < 0:
			animated_sprite_2d.play("jump")
		else:
			animated_sprite_2d.play("fall")

func _on_max_jump_height_timer_timeout() -> void:
	startJumping = false
