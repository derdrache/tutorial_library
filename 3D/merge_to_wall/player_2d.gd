extends CharacterBody3D

@onready var animated_sprite_3d: AnimatedSprite3D = $AnimatedSprite3D
@onready var ray_cast_3d: RayCast3D = $RayCast3D

const SPEED = 1.0
const JUMP_VELOCITY = 2.5

func _input(event):	
	if ray_cast_3d.is_colliding() and Input.is_action_just_pressed("actionQ"):
		_set_normal_mode()

func _set_normal_mode():
	var player = load("res://player_3d.tscn").instantiate()
	
	get_tree().current_scene.add_child(player)
	
	player.global_position = ray_cast_3d.global_position

	queue_free()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_axis("ui_left", "ui_right")
	var direction = (global_transform.basis * Vector3(0, 0, input_dir)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	_set_animation(input_dir)

	move_and_slide()

func _set_animation(direction):
	if direction > 0:
		animated_sprite_3d.flip_h = false
	elif direction < 0:
		animated_sprite_3d.flip_h = true
		
	if velocity:
		if velocity.y > 0:
			animated_sprite_3d.play("jump")
		else:
			animated_sprite_3d.play("walk")
	else:
		animated_sprite_3d.play("idle")
		
		
		
		
		
