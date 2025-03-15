extends CharacterBody3D

@export var speed := 4.0
@export var target: Node3D

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

func _ready() -> void:
	if not target: _set_target()

func _set_target():
	target = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	var nextPathPosition = navigation_agent_3d.get_next_path_position()
	
	var direction = global_position.direction_to(nextPathPosition)
	var calculateVelcotiy = direction * speed
	velocity = Vector3(calculateVelcotiy.x, velocity.y, calculateVelcotiy.z)
	
	look_at(target.global_position)
	
	move_and_slide()
	
	_update_target_position()

func _update_target_position():
	navigation_agent_3d.set_target_position(target.global_position)


func _on_navigation_agent_3d_target_reached() -> void:
	# do what ever you want
	pass
