extends CharacterBody3D

@export_category("Camera")
@export var camera_sens = 0.003
@export var cameraLimitDeg = 40

@onready var camera_pivot: Node3D = %cameraPivot
@onready var camera_3d: Camera3D = %Camera3D
@onready var animation_player: AnimationPlayer = $godot_plush/AnimationPlayer
@onready var godot_plush: Node3D = $godot_plush

@onready var ray_cast_3d: RayCast3D = $RayCast3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var slowSpeed = SPEED

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
	var direction := (camera_3d.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		var targetAngle = atan2(direction.x, direction.z) - rotation.y
		godot_plush.rotation.y = lerp_angle(godot_plush.rotation.y, targetAngle, 0.1)
		
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		if _is_on_ice():
			slowSpeed = 0.03
		elif ray_cast_3d.is_colliding():
			slowSpeed = SPEED
		
		velocity.x = move_toward(velocity.x, 0, slowSpeed)
		velocity.z = move_toward(velocity.z, 0, slowSpeed)
		
	_set_animation(direction)

	move_and_slide()

func _is_on_ice():
	if ray_cast_3d.is_colliding():
		return ray_cast_3d.get_collider().name == "Ice"
	
	return false

func _set_animation(direction):	
	if velocity.y > 0: animation_player.play("up")
	elif velocity.y < 0: animation_player.play("fall")
	elif direction: animation_player.play("run")
	else: animation_player.play("idle")
