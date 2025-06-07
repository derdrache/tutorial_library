extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D

const SPEED = 150.0
const JUMP_VELOCITY = -400.0
const PUSH_FORCE = 0.75

var isPushing = false

func _physics_process(delta: float) -> void:
	isPushing = false
	var speed = SPEED
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	_push_objects()
		
	_set_animation(direction)

	move_and_slide()

func _push_objects():
	var lastCollision = get_last_slide_collision()
	
	if lastCollision:
		var collider = lastCollision.get_collider()
		
		if "Stone" in collider.name:
			var pushDirection = (collider.global_position - global_position).normalized()
			
			var pushOnSide = abs(pushDirection.y) < 0.5
			
			if pushOnSide:
				isPushing = true
				var pushVelocity = Vector2(PUSH_FORCE * pushDirection)
				collider.velocity += pushVelocity

func _set_animation(direction):
	if direction < 0: animated_sprite_2d.flip_h = false
	elif direction > 0: animated_sprite_2d.flip_h = true
	
	if isPushing:
		animated_sprite_2d.play("push")
	elif is_on_floor():
		if velocity.x != 0:
			animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("idle")
	else:
		if velocity.y < 0:
			animated_sprite_2d.play("jump")
		else:
			animated_sprite_2d.play("fall")
