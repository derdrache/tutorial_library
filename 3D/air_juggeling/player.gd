extends CharacterBody3D

@onready var model: Node3D = $model
@onready var animation_player: AnimationPlayer = $model/AnimationPlayer
@onready var third_person_camera: Node3D = $thirdPersonCamera
@onready var hit_area: Area3D = $HitArea

const SPEED = 5.0
const JUMP_VELOCITY = 7.0

var damage = 2
var isAttacking = false
var attackWithUppercut = false

func _ready() -> void:
	add_to_group("player")
	hit_area.monitoring = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("actionQ") and not isAttacking:
		_attack()
	elif Input.is_action_just_pressed("actionE") and not isAttacking and is_on_floor():
		_uppercut()

	if isAttacking: 
		move_and_slide()
		return

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("movement_left", "movement_right", "movement_up", "movement_down")
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

func _attack():
	velocity.x = 0
	velocity.z = 0
	
	isAttacking = true
	
	animation_player.speed_scale = 2
	animation_player.play("1H_Melee_Attack_Slice_Horizontal")
	await animation_player.animation_finished
	
	isAttacking = false

func _uppercut():
	velocity.x = 0
	velocity.z = 0
	
	isAttacking = true
	attackWithUppercut = true
	
	animation_player.play_backwards("1H_Melee_Attack_Chop")
	
	await animation_player.animation_finished

	isAttacking = false
	attackWithUppercut = false

func _set_animation(direction):
	if direction:
		var targetAngle = atan2(direction.x, direction.z) - rotation.y
		model.rotation.y = lerp_angle(model.rotation.y, targetAngle, 0.1)
		
		animation_player.play("Running_A")
	else:
		animation_player.play("Idle")

func _on_hit_area_body_entered(body: Node3D) -> void:
	if body == self: return

	# on uppercut => bring the enemy in the air
	if attackWithUppercut:
		body.velocity.y = 8.0
		
	# if the player hit an enemy => hold in the air
	if not is_on_floor():
		velocity.y = 2

	if body.has_method("take_damage"):
		body.take_damage(damage)
