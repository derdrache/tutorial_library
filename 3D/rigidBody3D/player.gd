extends RigidBody3D

@export var movementSpeed := 0.5
@export var maxSpeed = 5
@export var turnSpeed := 1.5

func _physics_process(delta: float) -> void:
	var massMultiplicator = mass * 100
	
	var speedForce = Input.get_axis("ui_up", "ui_down") * movementSpeed * massMultiplicator
	var turnDegree = Input.get_axis("ui_right", "ui_left") * deg_to_rad(turnSpeed)
	
	rotate_y(turnDegree)
	 
	var force = global_transform.basis.z * speedForce
	apply_force(force)


func _integrate_forces(state: PhysicsDirectBodyState3D):
	_set_max_speed(state)

func _set_max_speed(state: PhysicsDirectBodyState3D):
	if state.linear_velocity.length() > maxSpeed:
		state.linear_velocity = state.linear_velocity.normalized() * maxSpeed
