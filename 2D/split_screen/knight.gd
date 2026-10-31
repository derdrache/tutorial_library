extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 300.0

var playerNumber: int

func _ready() -> void:
	add_to_group("player")
	
	_set_player_number()
	
func _set_player_number():
	playerNumber = int(name.split("Player")[1])
	
	if not playerNumber:
		playerNumber = 0

func _physics_process(_delta: float) -> void:
	var leftStickX = Input.get_joy_axis(playerNumber, JOY_AXIS_LEFT_X)
	var leftStickY = Input.get_joy_axis(playerNumber, JOY_AXIS_LEFT_Y)
	
	var direction := Vector2.ZERO
	direction.x = leftStickX if abs(leftStickX) > 0.1 else 0.0
	direction.y = leftStickY if abs(leftStickY) > 0.1 else 0.0

	if direction:
		velocity = direction.normalized() * SPEED
	else:
		velocity = Vector2.ZERO
		
	set_animation(direction)

	move_and_slide()

func set_animation(direction):
	if direction.x > 0: animated_sprite_2d.flip_h = false
	elif direction.x < 0: animated_sprite_2d.flip_h = true
	
	if velocity:
		animated_sprite_2d.play("walk")
	else:
		animated_sprite_2d.play("idle")
