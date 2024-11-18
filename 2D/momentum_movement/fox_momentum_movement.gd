extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const MAX_SPEED = 200.0
const JUMP_VELOCITY = -250.0

var speed := 0.0
var acceleration := 2.5
var lastDirection: float

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")
	
	calculate_speed(direction)
	lastDirection = direction
	
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	_set_animation()

	move_and_slide()
	
func _set_animation() -> void:
	if velocity.x < 0: animated_sprite_2d.flip_h = true
	elif velocity.x > 0: animated_sprite_2d.flip_h = false

	if velocity: animated_sprite_2d.play("move")
	else: animated_sprite_2d.play("idle")

func calculate_speed(direction: float) -> void:
	if lastDirection == direction: speed += acceleration
	else: speed = 0
	
	if speed > MAX_SPEED: speed = MAX_SPEED
