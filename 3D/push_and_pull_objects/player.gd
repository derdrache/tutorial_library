extends CharacterBody3D

@onready var model: Node3D = $model
@onready var animation_player: AnimationPlayer = $model/AnimationPlayer
@onready var third_person_camera: Node3D = $thirdPersonCamera
@onready var ray_cast_3d: RayCast3D = $model/RayCast3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var moveableObject: Node3D

func _physics_process(delta: float) -> void:
	var isMovebleObject = ray_cast_3d.is_colliding() and ray_cast_3d.get_collider().is_in_group("moveable_object")
	if Input.is_action_just_pressed("actionE") and isMovebleObject:
		_start_push_pull()

	if Input.is_action_just_released("actionE") and moveableObject:
		moveableObject.velocity = Vector3.ZERO
		moveableObject = null
	
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
	
	if moveableObject:
		direction = (model.global_transform.basis * -Vector3(0, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	_set_animation(direction)
	
	if moveableObject:
		moveableObject.velocity.x = velocity.x
		moveableObject.velocity.z = velocity.z

	move_and_slide()

func _start_push_pull():
	moveableObject = ray_cast_3d.get_collider()
	
	if ray_cast_3d.is_colliding():
		model.look_at(global_position + ray_cast_3d.get_collision_normal())

func _set_animation(direction):
	if direction:
		if not moveableObject:
			var targetAngle = atan2(direction.x, direction.z) - rotation.y
			model.rotation.y = lerp_angle(model.rotation.y, targetAngle, 0.1)
		
		animation_player.play("Running_A")
	else:
		animation_player.play("Idle")
