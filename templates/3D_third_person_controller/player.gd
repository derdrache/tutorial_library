extends CharacterBody3D

@export var camera_sens = 0.003
@export var cameraLimitDeg = 40

@onready var model: Node3D = %model
@onready var camera_pivot: Node3D = %cameraPivot

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
	var direction = (camera_pivot.global_transform.basis  * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		var targetAngle = atan2(direction.x, direction.z) - rotation.y
		model.rotation.y = lerp_angle(model.rotation.y, targetAngle, 0.1)
		
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

