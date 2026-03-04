extends CharacterBody3D

@onready var knight: Node3D = %Knight
@onready var animation_player: AnimationPlayer = $Knight/AnimationPlayer
@onready var third_person_camera: Node3D = $thirdPersonCamera
@onready var shield_collision_shape: CollisionShape3D = $Knight/Rig/Skeleton3D/Rectangle_Shield/StaticBody3D/ShieldCollisionShape

const SPEED = 5.0

var isBlocking = false

func _ready() -> void:
	shield_collision_shape.disabled = true

func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("right_mouse_click") and not isBlocking:
		_block()
	elif Input.is_action_just_released("right_mouse_click") and isBlocking:
		_block_release()
	
func _block():
	isBlocking = true
	animation_player.play("Blocking")
	shield_collision_shape.disabled = false

func _block_release():
	isBlocking = false
	shield_collision_shape.disabled = true

func _physics_process(delta: float) -> void:
	# Add the gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	if isBlocking:
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
	
func _set_animation(direction):
	if direction:
		var targetAngle = atan2(direction.x, direction.z) - rotation.y
		knight.rotation.y = lerp_angle(knight.rotation.y, targetAngle, 0.1)
			
		animation_player.play("Running_A")
	else:
		animation_player.play("Idle")
