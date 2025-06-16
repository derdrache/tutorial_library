extends CharacterBody3D

@onready var camera_target: Node3D = $Camera/CameraTarget
@onready var rotation_node: Node3D = %rotationNode
@onready var weapon_position_marker: Marker3D = $rotationNode/weaponPositionMarker

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var objectsInRange := []

func _ready() -> void:
	add_to_group("player")

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

func _process(delta: float) -> void:
	var hasWeapon = weapon_position_marker.get_child_count() > 0
	
	_select_nearest_object()
	
	if Input.is_key_pressed(KEY_E) and not objectsInRange.is_empty() and not hasWeapon:
		_pick_weapon()
	
	if Input.is_key_pressed(KEY_Q) and hasWeapon:
		_throw_weapon()

func _select_nearest_object():
	var nearestObject
	
	for object in objectsInRange:
		object.set_selection(false)
		
		if not nearestObject:
			nearestObject = object
		else:
			if nearestObject.global_position.distance_to(global_position) > object.global_position.distance_to(global_position):
				nearestObject = object
	
	if nearestObject:
		nearestObject.set_selection(true)

func _pick_weapon():
	var selectedWeapon = objectsInRange[0]
	selectedWeapon.reparent(weapon_position_marker)
	selectedWeapon.global_position = weapon_position_marker.global_position
	
	selectedWeapon.rotation_degrees = Vector3.ZERO

func _throw_weapon():
	var weapon = weapon_position_marker.get_child(0)
	var throwDirection = rotation_node.global_transform.basis.z
	
	weapon.throw(throwDirection)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Weapon:
		objectsInRange.append(body)


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is Weapon:
		objectsInRange.erase(body)
		body.set_selection(false)
