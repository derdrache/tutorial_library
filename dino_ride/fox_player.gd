extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

const SPEED = 100.0
const JUMP_VELOCITY = -250.0

var inUse = true

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	collision_shape_2d.disabled = not inUse
	
	if not inUse: 
		animated_sprite_2d.play("idle")
		return
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	_set_animation()

	move_and_slide()

func _set_animation():
	if velocity.x: animated_sprite_2d.flip_h = velocity.x < 0
	
	if velocity: animated_sprite_2d.play("run")
	else: animated_sprite_2d.play("idle")	
