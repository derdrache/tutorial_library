extends CharacterBody3D

@onready var camera_target: Node3D = $Camera/CameraTarget
@onready var rotation_node: Node3D = %rotationNode

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var enemiesInRange = []
var currentTarget
var selectionIndex = -1

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		_select_enemy()

func _select_enemy():
	if enemiesInRange.is_empty(): return
	
	_change_target_index()
	
	var target = enemiesInRange[selectionIndex]
	
	if target == currentTarget:
		_change_target_index()
		target = enemiesInRange[selectionIndex]
	
	_reset_selection()
	currentTarget = target
	target.set_selection(true)

func _change_target_index():
	if not currentTarget: 
		selectionIndex = 0
	else:
		selectionIndex += 1
		
	if selectionIndex > enemiesInRange.size() - 1:
		selectionIndex = 0

func _reset_selection():
	for enemy in enemiesInRange:
		enemy.set_selection(false)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

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
	
	direction.y = 0
	
	rotation_node.look_at(position + direction, Vector3.UP, true)
	
	move_and_slide()

func _on_targeting_area_body_entered(body: Node3D) -> void:
	if body in get_tree().get_nodes_in_group("enemy"):
		enemiesInRange.append(body)

func _on_targeting_area_body_exited(body: Node3D) -> void:
	if body in get_tree().get_nodes_in_group("enemy"):
		enemiesInRange.erase(body)
		body.set_selection(false)

func _target_lock_off():
	# use this on a key press to turn targeting off
	var selectionIndex = -1
	currentTarget = null
