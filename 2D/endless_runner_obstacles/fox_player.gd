extends CharacterBody2D

@export var health := 1

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 100.0
const JUMP_VELOCITY = -400.0

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
	if velocity.y: animated_sprite_2d.play("jump")
	else: animated_sprite_2d.play("walk")

func take_damage(damage):
	health -= damage
	
	if health <= 0: 
		queue_free()
		get_tree().create_timer(1).timeout.connect(get_tree().quit)
