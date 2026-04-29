extends CharacterBody3D

@onready var animation_player: AnimationPlayer = $Knight/AnimationPlayer

const SIDE_POSITION_DISTANCE = 5
const JUMP_VELOCITY = 5.0

var onAction = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	onAction = velocity.y != 0
	
	if Input.is_action_just_pressed("ui_left"):
		_move(1)
	elif Input.is_action_just_pressed("ui_right"):
		_move(-1)
	elif Input.is_action_just_pressed("ui_accept"):
		_jump()
	
	_set_animation()
	
	move_and_slide()

func _move(direction):
	var targetPositionX = global_position.x + SIDE_POSITION_DISTANCE * direction

	if targetPositionX < -SIDE_POSITION_DISTANCE or targetPositionX > SIDE_POSITION_DISTANCE or onAction:
		return
	
	onAction = true
	
	var tween = create_tween()
	tween.tween_property(self, "global_position:x", targetPositionX, 0.5)
	await tween.finished
	
	onAction = false

func _jump():
	if not is_on_floor(): return
	
	velocity.y = JUMP_VELOCITY

func _set_animation():
	if velocity.y > 0 or velocity.y < 0:
		animation_player.play("Jump_Full_Short")
	else:	
		animation_player.play("Running_A")
