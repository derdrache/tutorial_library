extends CharacterBody3D

@export var speed := 5.0
@export var jumpPower := 4.5

@onready var character_bear_2: Node3D = $character_bear2

var doDash = false
var canDash = true

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jumpPower
	
	if Input.is_action_just_pressed("dash") and canDash:
		_do_dash()
	
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (get_viewport().get_camera_3d().transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if doDash:
		var dashDirection = character_bear_2.transform.basis.z.normalized()
		velocity = dashDirection * speed * 5
		velocity.y = 0
	elif direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	var lookDirection = global_position + direction
	lookDirection.y = global_position.y

	character_bear_2.look_at(lookDirection, Vector3.UP, true)
	
	move_and_slide()

func _do_dash():
	canDash = false
	doDash = true
	
	var dashDuration = 0.2
	await get_tree().create_timer(dashDuration).timeout
	
	doDash = false
	
	var dashCoolDown = 2.0
	await get_tree().create_timer(dashCoolDown).timeout
	
	canDash = true
	
