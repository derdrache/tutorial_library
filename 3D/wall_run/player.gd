extends CharacterBody3D

@export var camera_sens = 0.003
@export var cameraLimitDeg = 40

@onready var knight: Node3D = %Knight
@onready var camera_pivot: Node3D = %cameraPivot
@onready var camera_3d: Camera3D = %Camera3D
@onready var animation_player: AnimationPlayer = $Knight/AnimationPlayer
@onready var ray_cast_right: RayCast3D = $RayCastRight
@onready var ray_cast_left: RayCast3D = $RayCastLeft

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event):
	if event.is_action_pressed("ui_cancel"): get_tree().quit()
	
	_camera_control(event)
	
func _camera_control(event):
	if event is InputEventMouseMotion:
		camera_pivot.rotation.y -= event.relative.x * camera_sens
		
		camera_pivot.rotation.x -= event.relative.y * camera_sens
		var limitRadians = deg_to_rad(cameraLimitDeg)
		camera_pivot.rotation.x = clampf(camera_pivot.rotation.x, -limitRadians, limitRadians)
	
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
	var direction = (camera_3d.global_transform.basis  * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction.y = 0
	
	if not is_on_floor() and _wall_on_side() and Input.is_action_pressed("dash"):
		_wall_run(direction)
	else:
		_normal_run(direction)
	
	_set_animation(direction)

	move_and_slide()

func _wall_on_side():
	return ray_cast_right.is_colliding() or ray_cast_left.is_colliding()

func _wall_run(direction):
	velocity.y = 0
	
	var wallNormal
	var collisionDistance
	var distanceOffset = 0.2
	
	if ray_cast_right.is_colliding():
		wallNormal = ray_cast_right.get_collision_normal()
		collisionDistance = ray_cast_right.get_collision_point().distance_to(global_position) - distanceOffset
		
		knight.rotation_degrees.z = -45
	elif ray_cast_left.is_colliding():
		wallNormal = ray_cast_left.get_collision_normal()
		collisionDistance = ray_cast_left.get_collision_point().distance_to(global_position) - distanceOffset
		
		knight.rotation_degrees.z = 45
		
	knight.position = collisionDistance * -wallNormal
	
	var directionVelocity = direction * (SPEED * 1.5)
	var parallelVelocity = directionVelocity - wallNormal * directionVelocity.dot(wallNormal)
	
	velocity = parallelVelocity
	
func _normal_run(direction):
	knight.rotation_degrees.z = 0
	knight.position = Vector3.ZERO
	
	if direction:
		var targetAngle = atan2(direction.x, direction.z) - rotation.y
		knight.rotation.y = lerp_angle(knight.rotation.y, targetAngle, 0.1)
		
		ray_cast_right.rotation.y = lerp_angle(knight.rotation.y, targetAngle, 0.1)
		ray_cast_left.rotation.y = lerp_angle(knight.rotation.y, targetAngle, 0.1)
		
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

func _set_animation(direction):
	if direction:
		animation_player.play("Running_A")
	else:
		animation_player.play("Idle")
