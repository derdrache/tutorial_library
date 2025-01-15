extends CharacterBody3D

@onready var camera_3d = $Camera3D
@onready var gun: Node3D = $Camera3D/Gun
@onready var ray_cast_3d: RayCast3D = $Camera3D/RayCast3D
@onready var sprite_3d: Sprite3D = $Camera3D/Sprite3D
@onready var bullet_target_position: Marker3D = $Camera3D/bulletTargetPosition

const BULLET_HOLE = preload("res://effects/bulletHole.tscn")
const BULLET_TRAIL = preload("res://effects/bulletTrail.tscn")

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const CAMERA_SENS = 0.003
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event):
	var onLeftClick = event is InputEventMouseButton and event.button_index == 1 and event.is_pressed()
	
	if event.is_action_pressed("ui_cancel"): get_tree().quit()
	
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * CAMERA_SENS
		rotation.x -= event.relative.y * CAMERA_SENS
		rotation.x = clamp(rotation.x, -0.5, 1.2)
	
	if onLeftClick: _hit_target()

func _hit_target():
	_create_bullet_trail()
	
	if not ray_cast_3d.is_colliding(): return
	
	var collider = ray_cast_3d.get_collider()
	
	if collider.is_in_group("enemy"): 
		var damage = gun.get_damage_value()
		collider.do_damage(damage)
	
	_create_bullet_hole()

func _create_bullet_trail():
	var bulletTrailNode = BULLET_TRAIL.instantiate()
	
	get_tree().current_scene.add_child(bulletTrailNode)
	bulletTrailNode.global_position = gun.get_bullet_spawn_point()
	
	var bulletDirection = bulletTrailNode.global_position.direction_to(bullet_target_position.global_position)
	bulletTrailNode.set_direction(bulletDirection)
	bulletTrailNode.look_at(bulletTrailNode.global_position + bulletDirection, Vector3.UP)

func _create_bullet_hole():
	var bulletHoleNode = BULLET_HOLE.instantiate()
	ray_cast_3d.get_collider().add_child(bulletHoleNode)
	bulletHoleNode.global_position = ray_cast_3d.get_collision_point()
	bulletHoleNode.look_at(bulletHoleNode.global_position + ray_cast_3d.get_collision_normal(), Vector3.UP)
	
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
