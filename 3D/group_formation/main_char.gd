extends CharacterBody3D

@onready var camera_target: Node3D = $Camera/CameraTarget
@onready var rotation_node: Node3D = %rotationNode
@onready var group_formation: Node3D = %GroupFormation

const CAMERA_SENS = 0.003
const SPEED = 5.0
const JUMP_VELOCITY = 4.5

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept"):
		var formationList = group_formation.Formation_Types.values()
		group_formation.change_formation(formationList.pick_random())

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := -(camera_target.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	rotation_node.look_at(position + direction, Vector3.UP, true)
	
	move_and_slide()

func get_transform_basis():
	return rotation_node.transform.basis
