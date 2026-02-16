extends CharacterBody3D

@onready var knight: Node3D = %Knight
@onready var animation_player: AnimationPlayer = $Knight/AnimationPlayer
@onready var third_person_camera: Node3D = $thirdPersonCamera
@onready var rocket_launcher: Node3D = $Knight/Rig/Skeleton3D/Rectangle_Shield/RocketLauncher

const SPEED = 5.0

var isShooting = false

func _ready() -> void:
	rocket_launcher.rocket_done.connect(_on_rocket_done)

func _on_rocket_done():
	isShooting = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("left_mouse_click") and not isShooting:
		_shoot()
		
	if isShooting:
		return

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (third_person_camera.global_transform.basis  * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction.y = 0
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	_set_animation(direction)

	move_and_slide()

func _shoot():
	isShooting = true
	
	animation_player.play("2H_Ranged_Shoot")
	await animation_player.animation_finished
	
	rocket_launcher.shoot()

func _set_animation(direction):
	if direction:
		var targetAngle = atan2(direction.x, direction.z) - rotation.y
		knight.rotation.y = lerp_angle(knight.rotation.y, targetAngle, 0.1)
		
		animation_player.play("Running_A")
	else:
		animation_player.play("Idle")
