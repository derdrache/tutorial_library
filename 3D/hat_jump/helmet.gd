extends CharacterBody3D

signal done()

const SPEED = 10.0
const MAX_DISTANCE = 10.0

var startPosition: Vector3
var maxDistanceReached := false

func _ready() -> void:
	add_to_group("hat")
	
	startPosition = global_position

func _physics_process(_delta: float) -> void:
	var player = get_tree().get_first_node_in_group("player")

	if startPosition.distance_to(global_position) > MAX_DISTANCE:
		maxDistanceReached = true
	elif maxDistanceReached and player.global_position.distance_to(global_position) < 1:
		done.emit()
		queue_free()
		
	var direction = global_transform.basis.z
	
	if maxDistanceReached:
		direction = global_position.direction_to(player.global_position)
	
	velocity = direction * SPEED
	
	move_and_slide()
