extends Node2D

@onready var lasers: Node2D = $lasers

var laserStartDirection = Vector2.UP
var length = 2000

func _ready() -> void:
	add_to_group("laser")
	
	refresh_laser()

func refresh_laser():
	for child in lasers.get_children():
		child.queue_free()
		
	_set_laser()

func _set_laser():
	var currentPoint = global_position
	var targetPoint = currentPoint + length * laserStartDirection
	var nextTarget = _ray_cast(currentPoint, targetPoint, self)
	var direction = laserStartDirection

	while nextTarget:
		var reflectDirection
		var nextPoint
		
		if nextTarget.collider.has_method("get_reflect_direction"):
			reflectDirection = nextTarget.collider.get_reflect_direction(direction)
		
		if reflectDirection:
			direction = reflectDirection
			_add_laser(currentPoint, nextTarget.collider.global_position)
			nextPoint = nextTarget.collider.global_position
		else:
			_add_laser(currentPoint, nextTarget.position)
			nextPoint = nextTarget.position
			break
			
		currentPoint = nextPoint
		targetPoint = currentPoint + length * direction
		nextTarget = _ray_cast(currentPoint, targetPoint, nextTarget.collider)

func _ray_cast(startPoint, targetPoint, excluded):
	var space_state = get_world_2d().direct_space_state
	var params = PhysicsRayQueryParameters2D.new()
	params.from = startPoint
	params.to = targetPoint
	params.exclude = [excluded]
	
	return space_state.intersect_ray(params)

func _add_laser(startPoint, endPoint):
	var line = Line2D.new()
	line.add_point(Vector2(0,0))
	line.add_point(endPoint- startPoint)
	line.default_color = Color.RED
	line.width = 2
	
	lasers.add_child(line)
	
	line.global_position = startPoint
