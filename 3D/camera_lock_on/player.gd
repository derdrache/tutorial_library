extends CharacterBody3D

@export var monster_selection_range:= -20.0
@export var camera_sens = 0.003
@export var cameraLimitDeg = 40 

@onready var model: Node3D = %model
@onready var camera_pivot: Node3D = %cameraPivot
@onready var camera_3d: Camera3D = %Camera3D
@onready var animation_player: AnimationPlayer = $model/Knight/AnimationPlayer
@onready var ray_cast_3d: RayCast3D = $RayCast3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var selectedEnemy: Node3D
var lockOnEnemy: Node3D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	_set_ray_cast_selection()
	
func _set_ray_cast_selection():
	ray_cast_3d.add_exception(self)
	ray_cast_3d.target_position = Vector3(0,0,monster_selection_range)

func _input(event):
	if event.is_action_pressed("ui_cancel"): get_tree().quit()
	
	if not lockOnEnemy: _camera_control(event)
	
	ray_cast_3d.rotation.y = camera_pivot.rotation.y
	
	_check_current_enemy()
	
	if Input.is_action_just_pressed("interaction") and not lockOnEnemy and selectedEnemy :
		lockOnEnemy = selectedEnemy
		lockOnEnemy.lock_on(true)
	elif Input.is_action_just_pressed("interaction") and lockOnEnemy:
		lockOnEnemy.lock_on(false)
		lockOnEnemy = null

func _camera_control(event):
	if event is InputEventMouseMotion:
		camera_pivot.rotation.y -= event.relative.x * camera_sens
		
		camera_pivot.rotation.x -= event.relative.y * camera_sens
		var limitRadians = deg_to_rad(cameraLimitDeg)
		camera_pivot.rotation.x = clampf(camera_pivot.rotation.x, -limitRadians, limitRadians)
	
func _check_current_enemy():
	if lockOnEnemy: return
	
	if ray_cast_3d.is_colliding() and "Enemy" in ray_cast_3d.get_collider().name:
		selectedEnemy = ray_cast_3d.get_collider()
		selectedEnemy.selected(true)
	else:
		if selectedEnemy:
			selectedEnemy.selected(false)
		selectedEnemy = null

func _physics_process(delta: float) -> void:
	if lockOnEnemy:
		_set_lock_on_camera()
	
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
		var targetAngle = atan2(direction.x, direction.z) - rotation.y
		model.rotation.y = lerp_angle(model.rotation.y, targetAngle, 0.1)
		
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	_set_animation(direction)

	move_and_slide()

func _set_lock_on_camera():
	camera_pivot.look_at(lockOnEnemy.global_position)
	camera_pivot.rotation.x = -0.68
	
func _set_animation(direction):
	if direction:
		animation_player.play("Running_A")
	else:
		animation_player.play("Idle")
