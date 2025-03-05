extends CharacterBody3D

@export var speed := 5.0
@export var jumpPower := 4.5
@export var turnSpeed := 1.5

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		$damageIndicator.create_indicator_label(randi_range(-50, 50))

func _physics_process(delta: float) -> void:
	## Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jumpPower

	# Handle turn
	var input_x = Input.get_axis("ui_right", "ui_left")
	rotate_y(input_x * deg_to_rad(turnSpeed))
	
	# Handle movement
	var input_y = Input.get_axis("ui_up", "ui_down")
	var direction = transform.basis.z * input_y
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	move_and_slide()
