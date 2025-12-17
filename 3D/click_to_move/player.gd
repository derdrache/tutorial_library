extends CharacterBody3D

@onready var animation_player: AnimationPlayer = $Barbarian/AnimationPlayer

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var targetPosition: Vector3

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if targetPosition:
		var direction = global_position.direction_to(targetPosition)
		velocity = direction * SPEED
		
		look_at(global_position + velocity, Vector3.UP, true)
		
		if global_position.distance_to(targetPosition) < 1:
			velocity = Vector3.ZERO
			targetPosition = Vector3.ZERO

	_set_animation()
	
	move_and_slide()

func _set_animation():
	if velocity.x:
		animation_player.play("Running_A")
	else:
		animation_player.play("Idle")
		
		
		
		
		
