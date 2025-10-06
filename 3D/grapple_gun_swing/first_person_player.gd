extends CharacterBody3D

@onready var camera_3d = $Camera3D
@onready var ray_cast_3d: RayCast3D = $Camera3D/RayCast3D
@onready var gun: CharacterBody3D = $Gun

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const CAMERA_SENS = 0.003
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var grapplePoint: Vector3

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event):
	if event.is_action_pressed("ui_cancel"): get_tree().quit()
	
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * CAMERA_SENS
		rotation.x -= event.relative.y * CAMERA_SENS
		rotation.x = clamp(rotation.x, -0.5, 1.2)

func _physics_process(delta):
	
	if Input.is_action_just_pressed("left_mouse_click") and ray_cast_3d.is_colliding() and not grapplePoint:
		grapplePoint = ray_cast_3d.get_collision_point()
		gun.shoot(grapplePoint)
	elif Input.is_action_just_pressed("left_mouse_click") and grapplePoint:
		grapplePoint = Vector3.ZERO
		gun.remove_line()
	
	if grapplePoint:
		_grap_swing(delta)
	else:
		_movement(delta)

	move_and_slide()

func _movement(delta):
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
		
func _grap_swing(delta):			
	var onGrapPoint = grapplePoint.distance_to(global_position) < 1

	var direction = abs(transform.basis.z) *  global_position.direction_to(grapplePoint) 

	velocity += direction * SPEED * 7 * delta
	
	if onGrapPoint:
		grapplePoint = Vector3.ZERO
		gun.remove_line()
		
		
		
