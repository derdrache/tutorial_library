extends CharacterBody3D

@onready var animation_player: AnimationPlayer = $Model/AnimationPlayer
@onready var model: Node3D = %Model
@onready var first_person_camera: Camera3D = $FirstPersonCamera
@onready var third_person_camera: Node3D = $thirdPersonCamera

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("shift"):
		_change_camera()

func _change_camera():
	if first_person_camera.current:
		model.show()
		first_person_camera.enable = false 
		third_person_camera.enable = true
	else:
		model.hide()
		first_person_camera.enable = true
		third_person_camera.enable = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (_get_camera_transform() * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		var targetAngle = atan2(direction.x, direction.z)
		model.rotation.y = lerp_angle(model.rotation.y, targetAngle, 0.1)
		
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	_set_animation(direction)

	move_and_slide()
	
func _get_camera_transform():
	if first_person_camera.current:
		return first_person_camera.global_transform.basis
	else:
		return third_person_camera.global_transform.basis

func _set_animation(direction):
	if direction:
		animation_player.play("Running_A")
	else:
		animation_player.play("Idle")
