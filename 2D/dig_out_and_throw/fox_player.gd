extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 100.0
const JUMP_VELOCITY = -250.0

func _ready() -> void:
	add_to_group("player")

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
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	_set_animation()
	
	move_and_slide()

func _set_animation():
	if velocity.x: animated_sprite_2d.flip_h = velocity.x < 0
	
	if velocity: animated_sprite_2d.play("walk")
	else: animated_sprite_2d.play("idle")	

func pick_up(duration):
	set_physics_process(false)
	
	animated_sprite_2d.play("idle")
	
	await get_tree().create_timer(duration).timeout
	
	set_physics_process(true)

func get_direction():
	if animated_sprite_2d.flip_h: return -1
	else: return 1
