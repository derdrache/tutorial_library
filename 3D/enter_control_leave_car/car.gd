extends CharacterBody3D

@onready var input_label: Label3D = %inputLabel
@onready var camera_3d: Camera3D = %Camera3D

const SPEED = 30.0
const JUMP_VELOCITY = 4.5

var withPlayer = false

func _ready() -> void:
	input_label.hide()

func _input(event: InputEvent) -> void:
	var canEnter = input_label.visible and not withPlayer
	var canLeave = withPlayer
	
	if Input.is_action_just_pressed("interaction") and canEnter:
		_enter_car()
	elif Input.is_action_just_pressed("interaction") and canLeave:
		_leave_car()

func _enter_car():
	withPlayer = true
	
	var player = get_tree().get_first_node_in_group("player")
	player.enter_car()

func _leave_car():
	withPlayer = false
	
	var player = get_tree().get_first_node_in_group("player")
	player.leave_car()
	player.global_position = global_position


func _physics_process(delta: float) -> void:
	if not withPlayer: return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (camera_3d.global_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		input_label.show()

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		input_label.hide()
