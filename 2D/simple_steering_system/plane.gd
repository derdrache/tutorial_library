extends CharacterBody2D

var maxSpeed = 400
var acceleration = 200
var turnSpeed = 4

var speed = 0
var forward = 0
var turn = 0

func _player_input_mouse():
	var mousePosition = get_global_mouse_position()
	var targetDirection = (global_position - mousePosition).normalized()
	var dot = transform.x.dot(targetDirection)
	
	if dot >0: forward = -1
	
	var angleToDirection = transform.x.angle_to(targetDirection)
	
	if angleToDirection > 0: turn = 1
	else: turn = -1

func _player_input_keys():
	forward = 0
	turn = 0
	
	if Input.is_action_pressed("move_up"):
		forward = -1
	elif Input.is_action_pressed("move_up"):
		forward = 1
		
	if Input.is_action_pressed("move_left"):
		turn = -1
	elif Input.is_action_pressed("move_right"):
		turn = 1

func _physics_process(delta):
	_player_input_mouse()
	
	speed += forward * acceleration * delta
	speed = clamp(speed, -maxSpeed, maxSpeed)
	
	rotation += turn * turnSpeed * delta
	
	velocity = transform.x * speed
	
	move_and_slide()
