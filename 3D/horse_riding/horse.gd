extends CharacterBody3D

@onready var ride_position_marker: Marker3D = %ridePositionMarker
@onready var dismount_position_marker: Marker3D = %dismountPositionMarker
@onready var third_person_camera: Node3D = %thirdPersonCamera

const SPEED = 5.0

var inRange = false

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("interaction") and inRange:
		_mount()
	elif Input.is_action_just_pressed("interaction") and _is_riding():
		_dismount()

func _mount():
	var playerModel = load("res://player_ride_scene.tscn").instantiate()
	ride_position_marker.add_child(playerModel)
	
	third_person_camera.enable = true
	
	var player = get_tree().get_first_node_in_group("player")
	player.queue_free()
	
func _dismount():
	ride_position_marker.get_child(0).queue_free()
	
	var playerNode = load("res://player.tscn").instantiate()
	get_tree().current_scene.add_child(playerNode)
	playerNode.global_position = dismount_position_marker.global_position
	
	third_person_camera.enable = false

func _physics_process(delta: float) -> void:
	third_person_camera.global_position = global_position + Vector3(0,2.5, 0)
	
	if not _is_riding(): return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (third_person_camera.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		var targetAngle = atan2(direction.x, direction.z)
		rotation.y = lerp_angle(rotation.y, targetAngle, 0.1)
		
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		inRange = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		inRange = false

func _is_riding():
	return ride_position_marker.get_child_count() > 0
