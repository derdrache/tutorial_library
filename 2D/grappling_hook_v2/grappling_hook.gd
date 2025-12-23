extends Node2D

@export var minRopeLength := 20
@export var maxRopeLength := 200

@onready var anchor: StaticBody2D = %Anchor
@onready var pin_joint_2d: PinJoint2D = %PinJoint2D
@onready var player_anchor: RigidBody2D = %PlayerAnchor
@onready var line_2d: Line2D = %Line2D

var speed = 3

func start_hook(hookPosition):
	anchor.global_position = hookPosition
	
	var player = get_tree().get_first_node_in_group("player")
	player_anchor.global_position = player.global_position
	player.reparent(player_anchor)

func _physics_process(_delta: float) -> void:
	var distanceToAnchor = player_anchor.global_position.distance_to(anchor.global_position)
	
	if Input.is_action_pressed("ui_right"):
		player_anchor.apply_central_impulse(player_anchor.global_transform.x * speed)
	elif Input.is_action_pressed("ui_left"):
		player_anchor.apply_central_impulse(player_anchor.global_transform.x * -speed)
	elif Input.is_action_pressed("ui_down"):
		if distanceToAnchor >= maxRopeLength: 
			return
	
		pin_joint_2d.node_b = ""
		player_anchor.global_position += player_anchor.global_transform.y * speed / 2
		pin_joint_2d.node_b = player_anchor.get_path()
	elif Input.is_action_pressed("ui_up"):
		if distanceToAnchor <= minRopeLength: 
			return
		
		pin_joint_2d.node_b = ""
		player_anchor.global_position -= player_anchor.global_transform.y * speed / 2
		pin_joint_2d.node_b = player_anchor.get_path()
		
	if Input.is_action_just_pressed("interaction"):
		_leave_rope()

func _leave_rope():
	await get_tree().create_timer(0.1).timeout
	
	var player = get_tree().get_first_node_in_group("player")
	player.reparent(get_tree().current_scene)
	player.set_active(true)
	player.rotation = 0
	
	queue_free()
	
func _process(_delta: float) -> void:
	line_2d.points[0] = player_anchor.global_position - global_position
	line_2d.points[1] = anchor.global_position - global_position
		
