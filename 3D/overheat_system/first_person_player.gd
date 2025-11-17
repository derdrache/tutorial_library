extends CharacterBody3D

signal shooted()

@onready var camera_3d = $Camera3D
@onready var ray_cast_3d: RayCast3D = %RayCast3D
@onready var raycast_end: Node3D = %raycastEnd
@onready var bullet_start_marker: Marker3D = %bulletStartMarker
@onready var over_heat_ui: Control = $CanvasLayer/OverHeatUi


const BULLET = preload("uid://1bie3s8whh7b")
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const CAMERA_SENS = 0.003
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var canShoot = true
var canReload = true

func _ready():
	add_to_group("player")
	
	over_heat_ui.over_heated.connect(_on_over_heated)
	over_heat_ui.done.connect(_on_over_heat_system_done)
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event):
	if event.is_action_pressed("ui_cancel"): get_tree().quit()
	
	if Input.is_action_just_pressed("left_mouse_click") and canShoot:
		_shoot()
	if Input.is_action_just_pressed("actionR") and canReload:
		_reload()
	
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * CAMERA_SENS
		rotation.x -= event.relative.y * CAMERA_SENS
		rotation.x = clamp(rotation.x, -0.5, 1.2)

func _shoot():
	var bulletNode = BULLET.instantiate()
	get_tree().current_scene.add_child(bulletNode)
	bulletNode.global_position = bullet_start_marker.global_position
	bulletNode.direction = _get_shoot_direction()
	bulletNode.look_at(raycast_end.global_position)
	
	shooted.emit()

func _reload():
	over_heat_ui.reload()
	canReload = false
	canShoot = false

func _get_shoot_direction():
	var targetPoint: Vector3
	
	if ray_cast_3d.is_colliding():
		targetPoint = ray_cast_3d.get_collision_point()
	else:
		targetPoint = raycast_end.global_position
	
	return bullet_start_marker.global_position.direction_to(targetPoint)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _on_over_heated():
	canShoot = false
	canReload = false

func _on_over_heat_system_done():
	canShoot = true
	canReload = true
	
	
	
