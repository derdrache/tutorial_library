extends CharacterBody2D

# for faster acceleration increase the value
@export var accelecrationValue = 0.01
# for longer sliding time reduce the value
@export var slideValue = 0.01
@export var fullStopValue = 15

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var floor_ray_cast: RayCast2D = $floorRayCast

const SPEED = 100.0
const JUMP_VELOCITY = -250.0

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
	
	if _is_on_ice():
		_movement_on_ice(direction)
	else:
		_normal_movement(direction)
		
	_set_animation(direction)

	move_and_slide()

func _movement_on_ice(direction):
	if direction:
		velocity.x =  lerp(velocity.x, direction * SPEED, accelecrationValue)
	else:
		velocity.x = lerp(velocity.x, 0.0, slideValue)
		
		if velocity.x < fullStopValue and velocity.x > -fullStopValue: 
			velocity.x = 0

func _normal_movement(direction):
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func _set_animation(direction) -> void:
	if direction < 0: animated_sprite_2d.flip_h = true
	elif direction > 0: animated_sprite_2d.flip_h = false

	if velocity: animated_sprite_2d.play("move")
	else: animated_sprite_2d.play("idle")

func _is_on_ice():
	var collider = floor_ray_cast.get_collider()
	
	if not collider: return false
	
	return collider.name == "iceBlocks"
