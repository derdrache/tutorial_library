extends CharacterBody3D


@export var target: Marker3D

@onready var animation_player: AnimationPlayer = $Barbarian/AnimationPlayer
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var targetIndex = 1

func _ready() -> void:
	add_to_group("player")
	
	navigation_agent_3d.target_position = target.global_position

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if navigation_agent_3d.is_navigation_finished():
		return
		
	var direction = global_position.direction_to(navigation_agent_3d.get_next_path_position())
	velocity = direction * SPEED
	
	look_at(global_position + velocity, Vector3.UP, true)

	_set_animation()
	
	move_and_slide()

func _set_animation():
	if velocity.x:
		animation_player.play("Running_A")
	else:
		animation_player.play("Idle")
