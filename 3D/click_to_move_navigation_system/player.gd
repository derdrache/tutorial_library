extends CharacterBody3D

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var animation_player: AnimationPlayer = $Barbarian/AnimationPlayer

const SPEED = 5.0

func _ready() -> void:
	add_to_group("player")
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if navigation_agent_3d.is_navigation_finished():
		velocity.x = 0
		velocity.z = 0
	else:
		var next_path_position: Vector3 = navigation_agent_3d.get_next_path_position()
		var direction = global_position.direction_to(next_path_position)
		var calculateVelocity = direction * SPEED
		calculateVelocity.y = velocity.y
		velocity = calculateVelocity
		
		look_at(global_position + velocity, Vector3.UP, true)

	_set_animation()

	move_and_slide()

func _set_animation():
	if velocity.x or velocity.z:
		animation_player.play("Running_A")
	else:
		animation_player.play("Idle")

func set_target_position(targetPosition):
	navigation_agent_3d.target_position = targetPosition
