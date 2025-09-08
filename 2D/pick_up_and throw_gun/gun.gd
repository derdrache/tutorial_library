extends CharacterBody2D
class_name GameObject

@export var throwForce = Vector2(150, -300)

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if is_on_floor():
		velocity = Vector2.ZERO
		
	move_and_slide()

func picked_up():
	collision_shape_2d.disabled = true
	
	set_physics_process(false)
	
func throw(direction):
	set_physics_process(true)
	velocity = throwForce
	velocity.x *= direction.x
	
	await get_tree().create_timer(0.1).timeout
	collision_shape_2d.disabled = false
