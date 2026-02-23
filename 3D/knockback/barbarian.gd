extends CharacterBody3D

@onready var animation_player: AnimationPlayer = $Barbarian/AnimationPlayer

const SPEED = 3.0

var knockbackVelocity: Vector3

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	var player = get_tree().get_first_node_in_group("player")
	var direction = global_position.direction_to(player.global_position)
	direction.y = 0
	
	velocity = direction * SPEED

	if knockbackVelocity:
		velocity = knockbackVelocity
	
	look_at(player.global_position, Vector3.UP, true)
	animation_player.play("Walking_A")
	
	move_and_slide()

func get_knockback(knockbackDirection, knockbackForce):
	knockbackVelocity = knockbackDirection * knockbackForce
	
	await get_tree().create_timer(0.1).timeout
	
	knockbackVelocity = Vector3.ZERO
