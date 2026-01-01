extends CharacterBody3D

@onready var rotation_node: Node3D = $rotationNode
@onready var camera_3d: Camera3D = $Camera3D
@onready var bullet_start_marker: Marker3D = $rotationNode/bulletStartMarker

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const BULLET = preload("res://bullet.tscn")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("left_mouse_click"): 
		_shoot()

	if _get_3d_mouse_position():
		rotation_node.look_at(_get_3d_mouse_position(), Vector3.UP, true)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (camera_3d.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _shoot():
	var bulletNode = BULLET.instantiate()
	
	var mouse3D = _get_3d_mouse_position()

	if not mouse3D: return

	bulletNode.direction = global_position.direction_to(mouse3D)

	get_tree().root.add_child(bulletNode)
	bulletNode.global_position = bullet_start_marker.global_position

func _get_3d_mouse_position():
	var mouse2DPosition := get_viewport().get_mouse_position()
	var currentCamera := get_viewport().get_camera_3d()
	var params := PhysicsRayQueryParameters3D.new()
	
	params.from = currentCamera.project_ray_origin(mouse2DPosition)
	params.to = currentCamera.project_position(mouse2DPosition, 100)
	
	var worldspace := get_world_3d().direct_space_state
	var intersect := worldspace.intersect_ray(params)
	
	if not intersect: return
	
	var intersectPosition = intersect.position
	intersectPosition.y = global_position.y
	
	return intersectPosition
	
	
