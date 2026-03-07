extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 50.0

var knockbackVelocity: Vector2

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
	
	animated_sprite_2d.flip_h = global_position.direction_to(player.global_position).x < 0
	
	animated_sprite_2d.play("walk")
	
	move_and_slide()

func get_knockback(knockbackDirection, knockbackForce):
	knockbackVelocity = knockbackDirection * knockbackForce
	
	await get_tree().create_timer(0.1).timeout
	
	knockbackVelocity = Vector2.ZERO
