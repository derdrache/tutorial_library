extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 100.0
const JUMP_VELOCITY = -300.0

const ICEBALL = preload("uid://dr3lgjywfkbs7")

var lastXDirection = 1

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("attack"):
		_shoot()

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	lastXDirection = direction
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	_set_animation(direction)

	move_and_slide()

func _shoot():
	
	var iceballNode = ICEBALL.instantiate()
	var direction = Vector2(lastXDirection, 0)
	iceballNode.set_direction(direction)
	
	get_tree().current_scene.add_child(iceballNode)
	
	iceballNode.global_position = global_position + direction * 16


func _set_animation(direction):
	if direction < 0: animated_sprite_2d.flip_h = true
	elif direction > 0: animated_sprite_2d.flip_h = false

	if velocity: animated_sprite_2d.play("move")
	else: animated_sprite_2d.play("idle")


	
	
	
