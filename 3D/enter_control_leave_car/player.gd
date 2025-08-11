extends CharacterBody3D

@export var camera_sens = 0.003
@export var cameraLimitDeg = 40

@onready var knight: Node3D = %Knight
@onready var camera_pivot: Node3D = %cameraPivot
@onready var camera_3d: Camera3D = %Camera3D
@onready var animation_player: AnimationPlayer = $Knight/AnimationPlayer

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

func _ready():
	add_to_group("player")
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
		knight.rotation.y=lerp_angle(knight.rotation.y, atan2(velocity.x,velocity.z), 0.1)
		animation_player.play("Running_A")
	else:
		animation_player.play("Idle")

func enter_car():
	set_physics_process(false)
	hide()
	camera_3d.current = false
	
func leave_car():
	set_physics_process(true)
	show()
	camera_3d.current = true
