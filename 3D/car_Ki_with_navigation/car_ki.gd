extends RigidBody3D

@export var speed = 2

@onready var car: Node3D = $Car
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

var checkPointIndex = 0

func _ready() -> void:
	car.top_level = true

func _physics_process(delta: float) -> void:
	if not navigation_agent_3d.target_position: _set_new_target()
	
	var next_path_position: Vector3 = navigation_agent_3d.get_next_path_position()
	next_path_position.y = global_position.y
	
	var velocity = global_position.direction_to(next_path_position) * speed
	
	linear_velocity = velocity
	
	car.global_position = global_position - Vector3(0,0.1,0)
	car.look_at(global_position - velocity)

func _set_new_target():
	var checkPoints = get_tree().get_nodes_in_group("checkPoints")
	if checkPoints.size() == checkPointIndex:
		navigation_agent_3d.target_position = get_tree().get_first_node_in_group("startPoint").global_position
		checkPointIndex = 0
	else:
		navigation_agent_3d.target_position = get_tree().get_nodes_in_group("checkPoints")[checkPointIndex].global_position
		checkPointIndex += 1

func _on_navigation_agent_3d_navigation_finished() -> void:
	_set_new_target()
