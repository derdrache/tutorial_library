extends CharacterBody3D

@onready var model: Node3D = $model
@onready var animation_player: AnimationPlayer = $model/AnimationPlayer
@onready var third_person_camera: Node3D = $thirdPersonCamera

@onready var helmet_start_marker: Marker3D = $model/helmetStartMarker
@onready var knight_helmet: BoneAttachment3D = $model/Rig/Skeleton3D/Knight_Helmet

const HELMET = preload("uid://ckjkpo81hf6x3")

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var hatThrown = false

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("actionQ") and not hatThrown:
		_throw_hat()
		
	if Input.is_action_pressed("actionQ") and Input.is_action_just_pressed("ui_accept") and hatThrown:
		_hat_jump()
	elif Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (third_person_camera.global_transform.basis  * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction.y = 0

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	_set_animation(direction)

	move_and_slide()

func _throw_hat():
	hatThrown = true
	
	knight_helmet.hide()
	
	var helmetNode = HELMET.instantiate()
	helmetNode.done.connect(_on_helm_throw_done)
	helmetNode.global_transform = helmet_start_marker.global_transform
	
	get_tree().current_scene.add_child(helmetNode)

func _on_helm_throw_done():
	knight_helmet.show()
	hatThrown = false

func _hat_jump():
	var hat = get_tree().get_first_node_in_group("hat")
	
	set_physics_process(false)
	hat.set_physics_process(false)
	
	var tween = create_tween()
	tween.tween_property(self, "global_position", hat.global_position, 0.5)
	await tween.finished
	
	hat.queue_free()
	
	set_physics_process(true)
	_on_helm_throw_done()

func _set_animation(direction):
	if direction:
		var targetAngle = atan2(direction.x, direction.z) - rotation.y
		model.rotation.y = lerp_angle(model.rotation.y, targetAngle, 0.1)
		
		animation_player.play("Running_A")
	else:
		animation_player.play("Idle")
