extends RigidBody2D

@export var currentplanet : StaticBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var ray_cast_2d = $RayCast2D

const MOVE_SPEED = 20
const JUMP_FORCE = -500

func _physics_process(delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	var planetDirection = global_position.direction_to(currentplanet.global_position)
	var force = Vector2.ZERO
	
	if _on_floor() and Input.is_action_just_pressed("ui_accept"):
		force += planetDirection * JUMP_FORCE
	
	if direction:
		force += planetDirection.orthogonal() * MOVE_SPEED * direction 
	
	_set_animation(direction)
	
	apply_central_impulse(force)
	
	look_at(currentplanet.global_position)

func _on_floor():
	if ray_cast_2d.is_colliding(): return true
	
func _integrate_forces(state):
	rotation_degrees = 0
	
func _set_animation(direction):
	if direction > 0: animated_sprite_2d.flip_h = false
	elif direction < 0: animated_sprite_2d.flip_h = true
	
	if abs(linear_velocity.x) > 0.1: animated_sprite_2d.play("walk")
	else: animated_sprite_2d.play("idle")
