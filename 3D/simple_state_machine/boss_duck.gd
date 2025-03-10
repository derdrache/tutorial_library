extends CharacterBody3D

@export var target: Node3D

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var state_nodes: Node = $StateNodes

enum States {IDLE, FOLLOW, PUSH_BACK}

var currentState: States = States.IDLE

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	state_nodes.get_children()[currentState].do()

	move_and_slide()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == get_tree().get_first_node_in_group("player") and currentState == States.IDLE:
		target = body
		currentState = States.FOLLOW

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body == get_tree().get_first_node_in_group("player") and currentState == States.FOLLOW:
		target = null
		currentState = States.IDLE

func _on_navigation_agent_3d_target_reached() -> void:
	currentState = States.PUSH_BACK
