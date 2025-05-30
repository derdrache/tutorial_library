extends CharacterBody2D
class_name Egg

const SPEED = 300
const BOUNCE_SPEED_MODIFIER = 1.3

var shootDirection: Vector2

func _physics_process(delta):
	if not shootDirection: return
		
	var collisionInfo = move_and_collide(velocity * delta)
	
	if collisionInfo:
		velocity = velocity.bounce(collisionInfo.get_normal())
		velocity *= BOUNCE_SPEED_MODIFIER

func shoot(targetPosition):
	shootDirection = (targetPosition - global_position).normalized()	
	
	velocity = shootDirection * SPEED
	
	await get_tree().create_timer(2.0).timeout
	
	queue_free()
