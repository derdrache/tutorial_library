extends CharacterBody3D

@onready var knight: Node3D = %Knight
@onready var animation_player: AnimationPlayer = $Knight/AnimationPlayer
@onready var third_person_camera: Node3D = $thirdPersonCamera

const SPEED = 5.0

var isAttacking = false

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("left_mouse_click") and not isAttacking:
		isAttacking = true
		animation_player.play("1H_Melee_Attack_Slice_Horizontal")

	if isAttacking:
		return

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

func _set_animation(direction):
	if direction:
		var targetAngle = atan2(direction.x, direction.z) - rotation.y
		knight.rotation.y = lerp_angle(knight.rotation.y, targetAngle, 0.1)
		
		animation_player.play("Running_A")
	else:
		animation_player.play("Idle")

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == self: return
	
	if body.has_method("get_knockback"):
		var knockbackDirection = global_position.direction_to(body.global_position)
		knockbackDirection.y = 0
		body.get_knockback(knockbackDirection, 50)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if "Attack" in anim_name:
		isAttacking = false
