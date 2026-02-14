extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var flash_light: PointLight2D = $flashLight

const SPEED = 200.0

var targetPosition: Vector2

func _ready() -> void:
	flash_light.enabled = false

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("leftClick"):
		targetPosition = get_global_mouse_position()
	elif Input.is_action_just_pressed("rightClick"):
		flash_light.enabled = not flash_light.enabled

func _physics_process(_delta: float) -> void:
	
	if targetPosition:
		flash_light.look_at(targetPosition)
	
	_set_velocity()
	
	_set_animation()

	move_and_slide()

func _set_velocity():
	if not targetPosition: return
	
	var direction = global_position.direction_to(targetPosition)
	velocity = direction * SPEED
	
	if global_position.distance_to(targetPosition) < 8:
		velocity = Vector2.ZERO
		targetPosition = Vector2.ZERO

func _set_animation():
	if velocity.x > 0: animated_sprite_2d.flip_h = false
	elif velocity.x < 0: animated_sprite_2d.flip_h = true
	
	if velocity:
		animated_sprite_2d.play("walk")
	else:
		animated_sprite_2d.play("idle")
