extends StaticBody3D

@export var startDirection := Vector3.FORWARD
@export var laserRange: float = 20.0

@onready var laser_start_marker: Marker3D = $laserStartMarker

const LASER_MESH = preload("uid://ea5c4d3jlgjl")

func _ready() -> void:
	_set_laser()

func _set_laser():
	var startPoint = laser_start_marker.global_position
	var direction = startDirection
	var laserHeight = laser_start_marker.global_position.y
	var target = _ray_cast(startPoint, startPoint + direction * laserRange, self)

	while target:
		if target.collider is ReflectionArea:
			direction = direction.bounce(target.normal)
		
			_add_laser(startPoint, target.position)
			
			startPoint = target.collider.global_position
			startPoint.y = laserHeight
			target = _ray_cast(startPoint, startPoint + direction * laserRange, target.collider)
		else:
			target = null

	_add_laser(startPoint, startPoint + direction * laserRange)

func _ray_cast(startPoint, targetPoint, excluded):
	var space_state = get_world_3d().direct_space_state
	var params := PhysicsRayQueryParameters3D.new()
	params.collide_with_areas = true
	params.from = startPoint
	params.to = targetPoint
	params.exclude = [excluded]
	
	return space_state.intersect_ray(params)

func _add_laser(startPosition:Vector3, endPosition):
	var laserNode:Node3D = LASER_MESH.instantiate()
	laser_start_marker.add_child(laserNode)

	laserNode.global_position = startPosition - (startPosition - endPosition) / 2.0
	laserNode.global_position.y = startPosition.y
	laserNode.get_child(0).mesh.height = startPosition.distance_to(endPosition)
	
	laserNode.rotate_y(rad_to_deg(laserNode.global_position.angle_to(endPosition)))
	
	laserNode.look_at(endPosition)
