extends CharacterBody3D

@onready var model: Node3D = %Model
@onready var animation_player: AnimationPlayer = $Model/AnimationPlayer
@onready var third_person_camera: Node3D = $thirdPersonCamera
@onready var ray_cast_3d: RayCast3D = $RayCast3D

const SPEED = 7.0
const JUMP_VELOCITY = 4.5


func _physics_process(delta: float) -> void:
	third_person_camera.global_position = global_position + Vector3(0,2,0)
	
	var floorNormal: Vector3 = ray_cast_3d.get_collision_normal()
	
	# Add the gravity.
	if not is_on_floor():
		floorNormal = Vector3.UP
		velocity += get_gravity() * delta

	var floorQuaternion := Quaternion(transform.basis.y, floorNormal)	
	transform.basis = Basis(floorQuaternion * basis.get_rotation_quaternion())

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (third_person_camera.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		var targetAngle = atan2(direction.x, direction.z) - rotation.y
		model.rotation.y = lerp_angle(model.rotation.y, targetAngle, 0.1)
		
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	_set_animation(direction)

	move_and_slide()

func _set_animation(direction):
	if direction:		
		animation_player.play("Running_A")
	else:
		animation_player.play("Idle")
