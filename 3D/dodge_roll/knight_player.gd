extends CharacterBody3D

@onready var knight: Node3D = $knight_modified
@onready var animation_player: AnimationPlayer = $knight_modified/AnimationPlayer
@onready var third_person_camera: Node3D = $thirdPersonCamera
@onready var dodge_cooldown_timer: Timer = $dodgeCooldownTimer
@onready var hurt_box: Area3D = $HurtBox

const SPEED = 5.0

var isDodging = false
var dodgeDirection: Vector3

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (third_person_camera.global_transform.basis  * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction.y = 0
	
	var hasDodgeCooldown = dodge_cooldown_timer.time_left
	var canDodge = not hasDodgeCooldown and direction and Input.is_action_pressed("ui_accept")
	var dodgeMultiplier = 1
	
	if canDodge:
		dodgeDirection = direction
		_dodge()
		
	if isDodging:
		direction = dodgeDirection
		dodgeMultiplier = 1.5
		
	if direction:			
		velocity.x = direction.x * SPEED * dodgeMultiplier
		velocity.z = direction.z * SPEED * dodgeMultiplier
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	_set_animation(direction)

	move_and_slide()

func _dodge():
	isDodging = true
	
	animation_player.play("Dodge_Roll")
	hurt_box.monitorable = false
	
	await animation_player.animation_finished
	
	isDodging = false
	dodgeDirection = Vector3.ZERO
	hurt_box.monitorable = true
	
	dodge_cooldown_timer.start()

func _set_animation(direction):
	if isDodging: 
		knight.look_at(global_position + direction, Vector3.UP, true)
		return
		
	if direction:
		var targetAngle = atan2(direction.x, direction.z) - rotation.y
		knight.rotation.y = lerp_angle(knight.rotation.y, targetAngle, 0.1)
		
		animation_player.play("Running_A")
	else:
		animation_player.play("Idle")
