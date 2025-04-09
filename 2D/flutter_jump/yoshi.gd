extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var flutter_jump_timer: Timer = $flutterJumpTimer

const SPEED = 150.0

var JUMP_VELOCITY = -400.0
var doFlutterJump = false
var canFlutterJump = true

func _physics_process(delta: float) -> void:
	var speed = SPEED
	
	if not is_on_floor() and not doFlutterJump:
		velocity += get_gravity() * delta
	elif is_on_floor():
		canFlutterJump = true
		
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_pressed("ui_accept") and velocity.y > 0 and canFlutterJump:
		_start_flutter_jump()
	elif not Input.is_action_pressed("ui_accept"):
		doFlutterJump = false
		
	if doFlutterJump:
		velocity.y -= 2
		speed = SPEED / 3
		
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	_set_animation(direction)

	move_and_slide()

func _start_flutter_jump():
	doFlutterJump = true
	canFlutterJump = false
	velocity.y = 50
	flutter_jump_timer.start()
		
func _set_animation(direction):
	if direction < 0: animated_sprite_2d.flip_h = false
	elif direction > 0: animated_sprite_2d.flip_h = true
	
	if is_on_floor():
		if velocity.x != 0:
			animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("idle")
	else:
		if doFlutterJump:
			animated_sprite_2d.play("flutter_jump")
		else:
			if velocity.y < 0:
				animated_sprite_2d.play("jump")
			else:
				animated_sprite_2d.play("fall")

func _on_flutter_jump_timer_timeout() -> void:
	doFlutterJump = false
