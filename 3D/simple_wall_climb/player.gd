extends CharacterBody3D

@onready var model: Node3D = $model
@onready var animation_player: AnimationPlayer = $model/AnimationPlayer
@onready var third_person_camera: Node3D = $thirdPersonCamera
@onready var front_ray_cast: RayCast3D = $model/frontRayCast

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

func _physics_process(delta: float) -> void:
	if _can_climb():
		_climb_movement()
	else:
		_floor_movement(delta)

	_set_animation()

	move_and_slide()

func _climb_movement():
	var newBasis = Basis.looking_at(front_ray_cast.get_collision_normal())
	
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (newBasis * Vector3(-input_dir.x, -input_dir.y, 0)).normalized()

	velocity = direction * SPEED

func _floor_movement(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (third_person_camera.global_transform.basis  * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction.y = 0

	if direction:
		var targetAngle = atan2(direction.x, direction.z) - rotation.y
		model.rotation.y = lerp_angle(model.rotation.y, targetAngle, 0.1)
		
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

func _set_animation():
	if _can_climb():
		animation_player.play("Cheer")
	elif velocity:
		animation_player.play("Running_A")
	else:
		animation_player.play("Idle")

func _can_climb():
	return front_ray_cast.is_colliding()
