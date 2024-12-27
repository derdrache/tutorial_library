extends RigidBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var ray_cast_2d = $RayCast2D

const MOVE_SPEED = 50
const MAX_SPEED = 100
const JUMP_FORCE = -300

func _physics_process(delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	var force = Vector2.ZERO
	
	if direction:
		force.x = MOVE_SPEED * direction
		if abs(linear_velocity.x) > MAX_SPEED: linear_velocity.x = MAX_SPEED * direction
	
	if _on_floor() and Input.is_action_just_pressed("ui_accept"):
		force.y = JUMP_FORCE
	
	_set_animation(direction)
	
	apply_central_impulse(force)
	
func _integrate_forces(state):
	rotation_degrees = 0
	
func _set_animation(direction):
	if direction > 0: animated_sprite_2d.flip_h = false
	elif direction < 0: animated_sprite_2d.flip_h = true
	
	if not _on_floor(): animated_sprite_2d.play("jump")
	elif abs(linear_velocity.x) > 0.1: animated_sprite_2d.play("run")
	else: animated_sprite_2d.play("idle")
	
func _on_floor():
	if ray_cast_2d.is_colliding(): return true
