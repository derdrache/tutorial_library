extends CharacterBody3D

@onready var camera_target: Node3D = $Camera/CameraTarget
@onready var rotation_node: Node3D = %rotationNode

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var objectsInRange := []

func _ready() -> void:
	add_to_group("player")

func _process(delta: float) -> void:
	_set_nearest_object()

func _set_nearest_object():
	if objectsInRange.is_empty(): return
	
	var nearestObject
	
	for object in objectsInRange:
		object.set_selection(false)
		
		if not nearestObject:
			nearestObject = object
		else:
			if nearestObject.global_position.distance_to(global_position) > object.global_position.distance_to(global_position):
				nearestObject = object
		
	nearestObject.set_selection(true)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (camera_target.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	direction.y = 0
	
	rotation_node.look_at(position + direction, Vector3.UP, true)
	
	move_and_slide()


func _on_interaction_area_body_entered(body: Node3D) -> void:
	if body in get_tree().get_nodes_in_group("object"):
		objectsInRange.append(body)

func _on_interaction_area_body_exited(body: Node3D) -> void:
	if body in get_tree().get_nodes_in_group("object"):
		body.set_selection(false)
		objectsInRange.erase(body)
