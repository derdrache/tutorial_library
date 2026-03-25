@tool
extends CollisionShape3D

signal changed()

var randomGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	shape.changed.connect(changed.emit)

func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		changed.emit()

func get_random_position():	
	if shape is CylinderShape3D:
		var radius = shape.radius
		var randomPosition = global_position + _get_random_point_cylinder_shape(radius)

		return randomPosition

func _get_random_point_cylinder_shape(radius):
	var randomAngle = randomGenerator.randf_range(0, 2 * PI)
	var randomLength = radius * sqrt(randomGenerator.randf())
	var direction = Vector3.RIGHT.rotated(Vector3.UP, randomAngle)
	
	return direction * randomLength
