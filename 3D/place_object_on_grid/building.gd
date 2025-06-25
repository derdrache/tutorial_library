extends StaticBody3D

@export var size: Vector2 = Vector2(2,2)	
@export var offset: Vector3 = Vector3.ZERO

func _ready() -> void:
	for child in get_children():
		child.position -= offset

func get_rect():
	var objectPosition = Vector2(
		global_position.x - int(size.x /2), 
		global_position.z - int(size.y /2)
		)
	
	return Rect2(objectPosition, size)
