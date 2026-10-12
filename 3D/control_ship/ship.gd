extends CharacterBody3D

@onready var third_person_camera: Node3D = $thirdPersonCamera

const SPEED = 25.0

var inUse = false

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("actionQ") and inUse:
		_leave_steering()

func _leave_steering():
	inUse = false

	var player: CharacterBody3D = get_tree().get_first_node_in_group("player")
	player.set_physics_process(true)
	player.reparent(get_tree().current_scene)
	player.collision_layer = 1
	third_person_camera.current = false

func _physics_process(_delta: float) -> void:
	if not inUse:
		return
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(0, 0, input_dir.y)).normalized()
	
	if input_dir.x:
		rotation.y -= input_dir.x * 0.02
	
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _on_interaction_area_interaction_started() -> void:
	inUse = true
	
	var player: CharacterBody3D = get_tree().get_first_node_in_group("player")
	player.set_physics_process(false)
	player.reparent(self)
	player.collision_layer = 0
	third_person_camera.current = true
