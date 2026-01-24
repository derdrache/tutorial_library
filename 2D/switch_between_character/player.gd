extends CharacterBody2D

@export var active = false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera_2d: Camera2D = $Camera2D

const SPEED = 100.0
const JUMP_VELOCITY = -200.0

func _ready() -> void:
	add_to_group("player")
	
	camera_2d.enabled = active

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("interaction"):
		active = not active
		camera_2d.enabled = active

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if not active: 
		move_and_slide()
		return
		
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

	_set_animation()
	
	move_and_slide()

func _set_animation():
	if velocity.x > 0: animated_sprite_2d.flip_h = false
	elif velocity.x < 0: animated_sprite_2d.flip_h = true
	
	if velocity:
		animated_sprite_2d.play("walk")
	else:
		animated_sprite_2d.play("idle")
