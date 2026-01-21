extends CharacterBody3D

@export var waterMesh: MeshInstance3D
@export var speed := 3.0

var targetPosition: Vector3
var targetReachedDistance := 0.3

func _ready() -> void:
	targetPosition = _get_target_position()

func _get_target_position():
	var half_size = waterMesh.mesh.size / 2
	
	return Vector3(
		randf_range(waterMesh.global_position.x - half_size.x, waterMesh.global_position.x + half_size.x),
		randf_range(waterMesh.global_position.y - half_size.y, waterMesh.global_position.y + half_size.y),
		randf_range(waterMesh.global_position.z - half_size.z, waterMesh.global_position.z + half_size.z),
	)

func _physics_process(_delta: float) -> void:
	if global_position.distance_to(targetPosition) < targetReachedDistance:
		targetPosition = _get_target_position()
	
	var direction = global_position.direction_to(targetPosition)
	velocity = direction * speed
	
	look_at(global_position + direction, Vector3.UP, true)
	
	move_and_slide()
