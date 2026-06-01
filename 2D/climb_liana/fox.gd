extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 100.0
const JUMP_VELOCITY = -300.0

var canClimb = false:
	set(value):
		canClimb = value
		
		if value and not is_on_floor():
			doClimb = true
		elif not value:
			doClimb = false
var doClimb = false
var doAction = false

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	if canClimb and Input.is_action_pressed("ui_up") and not doAction:
		doClimb = true

	if doClimb:
		_climb_movement()
	else:
		_normal_movement(delta)
	
	move_and_slide()

func _climb_movement():
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction:
		velocity = direction * (SPEED / 2)
	else:
		velocity = Vector2.ZERO

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"): 
		doClimb = false
		velocity.y = JUMP_VELOCITY
		_set_action(0.2)
		
	_set_climb_animation()

func _set_climb_animation():
	animated_sprite_2d.play("climb")
	
	if not velocity:
		animated_sprite_2d.stop()

func _normal_movement(delta):
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
	
	_set_normal_movement_animation(direction)

func _set_normal_movement_animation(direction):
	if direction < 0: animated_sprite_2d.flip_h = true
	elif direction > 0: animated_sprite_2d.flip_h = false

	if velocity: animated_sprite_2d.play("move")
	else: animated_sprite_2d.play("idle")

func _set_action(duration: float):
	doAction = true
	
	await get_tree().create_timer(duration).timeout
	
	doAction = false
