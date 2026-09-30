extends CharacterBody3D

@onready var model: Node3D = $model
@onready var animation_player: AnimationPlayer = $model/AnimationPlayer
@onready var third_person_camera: Node3D = $thirdPersonCamera
@onready var ray_cast_3d: RayCast3D = $model/RayCast3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var climbingCollision: Node3D
var isClimbing = false

func _input(_event: InputEvent) -> void:
	var climbingObject = ray_cast_3d.is_colliding() and ray_cast_3d.get_collider().is_in_group("ClimbingTree")
	var canClimb = climbingObject and not isClimbing
	
	if Input.is_action_just_pressed("actionE") and canClimb:
		_start_climbing()
	elif isClimbing and Input.is_action_just_pressed("actionE"):
		_stop_climbing()

func _start_climbing():
	climbingCollision = ray_cast_3d.get_collider().get_node("CollisionShape3D")
	
	if not climbingCollision:
		return
	
	isClimbing = true
	reparent(climbingCollision)
	
	var targetPosition = climbingCollision.global_position
	targetPosition.y = global_position.y
	model.look_at(targetPosition, Vector3.UP, true)

func _stop_climbing():
	isClimbing = false
	climbingCollision = null
	reparent(get_tree().current_scene)

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if climbingCollision:
		_climb(input_dir)
		return
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
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

func _climb(input_dir):
	if input_dir.x:
		climbingCollision.rotation.y += input_dir.x * 0.015
	if input_dir.y:
		velocity.y = -input_dir.y * SPEED / 2
		move_and_slide()

func _set_animation(direction):
	if direction:
		var targetAngle = atan2(direction.x, direction.z) - rotation.y
		model.rotation.y = lerp_angle(model.rotation.y, targetAngle, 0.1)
		
		animation_player.play("Running_A")
	else:
		animation_player.play("Idle")
