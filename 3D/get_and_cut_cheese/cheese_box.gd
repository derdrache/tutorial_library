extends StaticBody3D
class_name object_storage

@export var object: PackedScene

func get_object():
	return object.instantiate()
