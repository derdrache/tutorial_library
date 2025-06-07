extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if velocity.x: 
		velocity.x *= 0.995
		
	sprite_2d.rotate(velocity.x / 750.0)
	
	move_and_slide()
