extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D

enum STOMP_STATES{NONE, START, DO, END}

const SPEED = 150.0

var JUMP_VELOCITY = -400.0
var currentStompState: STOMP_STATES = STOMP_STATES.NONE

func _physics_process(delta: float) -> void:
	var speed = SPEED
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("ui_down") and not is_on_floor() and currentStompState != STOMP_STATES.DO:
		currentStompState = STOMP_STATES.START
	
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	match currentStompState:
		STOMP_STATES.START: velocity = Vector2.ZERO
		STOMP_STATES.DO, STOMP_STATES.END: velocity.x = 0

	if is_on_floor() and currentStompState == STOMP_STATES.DO:
		_end_stomp()
		
	_set_animation(direction)

	move_and_slide()
		
func _set_animation(direction):
	if direction < 0: animated_sprite_2d.flip_h = false
	elif direction > 0: animated_sprite_2d.flip_h = true

	if currentStompState == STOMP_STATES.START:
		animated_sprite_2d.play("stomp")
	elif currentStompState == STOMP_STATES.DO or currentStompState == STOMP_STATES.END:
		animated_sprite_2d.play("stomp_fall")
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

func _end_stomp():
	currentStompState = STOMP_STATES.END
	
	_set_camera_shake(true)
	
	var collisionObject = get_slide_collision(0).get_collider()
	
	if collisionObject.has_method("on_stomp"):
		collisionObject.on_stomp()
	
	await get_tree().create_timer(0.25).timeout
	
	currentStompState = STOMP_STATES.NONE
	
	_set_camera_shake(false)

func _set_camera_shake(boolean: bool):
	var camera = get_tree().get_first_node_in_group("camera")
	
	camera.shake_camera(5, 0.15)


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "stomp":
		currentStompState = STOMP_STATES.DO


		
		
		
		
