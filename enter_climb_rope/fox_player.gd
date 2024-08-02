extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var area_2d = $Area2D


const SPEED = 100.0
const JUMP_VELOCITY = -300.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var onRope = false

func _physics_process(delta):
	if not is_on_floor() && not onRope:
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() || onRope):	
		if onRope: _exit_rope()
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("ui_left", "ui_right")
	var climbDirection = Input.get_axis("ui_up", "ui_down")
	
	if onRope:
		if climbDirection: position.y += climbDirection 
	else:
		if direction && not onRope:
			velocity.x = direction * SPEED
		elif not direction && not onRope:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
	_set_animation(climbDirection)
	
	move_and_slide()

func _set_animation(climbDirection): 
	if velocity.x > 0: animated_sprite_2d.flip_h = false
	elif velocity.x < 0: animated_sprite_2d.flip_h = true
	
	if onRope:
		animated_sprite_2d.play("climb")
		if climbDirection == 0: animated_sprite_2d.stop()
	elif velocity == Vector2.ZERO: animated_sprite_2d.play("idle")
	elif velocity.y > 0 && not is_on_floor(): animated_sprite_2d.play("falling")
	elif velocity.y < 0 && not is_on_floor(): animated_sprite_2d.play("jump")
	else: animated_sprite_2d.play("walk")

func _enter_rope(area):
	onRope = true
	reparent(area)
	global_position = area.get_rope_position(self)
	rotation_degrees = 0
	velocity = Vector2.ZERO

func _exit_rope():
	area_2d.monitoring = false
	onRope = false
	reparent(get_tree().current_scene)
	rotation_degrees = 0
	
	await get_tree().create_timer(0.2).timeout
	
	area_2d.monitoring = true

func _on_area_2d_area_entered(area):
	if area.is_in_group("rope") && not onRope:
		call_deferred("_enter_rope", area)

func _on_area_2d_area_exited(area):
	if area.is_in_group("rope") && onRope:
		_exit_rope()
