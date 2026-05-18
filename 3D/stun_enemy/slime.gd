extends CharacterBody3D

@onready var animation_player: AnimationPlayer = $slime/AnimationPlayer
@onready var slime: Node3D = $slime
@onready var stun_sprite: Sprite3D = $stunSprite

const SPEED = 3.0

var health := 5
var stunTime := 0.0

func _physics_process(delta: float) -> void:
	stun_sprite.visible = stunTime > 0

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if stunTime:
		_handle_stun(delta)
		return
	
	_handle_movement()
	
	_set_animation()
	
	move_and_slide()

func _handle_stun(delta):
	stunTime -= delta
	if stunTime < 0: 
		stunTime = 0
	animation_player.stop()

func _handle_movement():
	var player = get_tree().get_first_node_in_group("player")
	if not player: return
	
	var direction = global_position.direction_to(player.global_position)
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	slime.look_at(player.global_position, Vector3.UP, true)

func _set_animation():
	if velocity.x or velocity.z:
		animation_player.play("walk")
	else:
		animation_player.play("idle")

func take_damage(value):
	health -= value
	stunTime = 2.0
