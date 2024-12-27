extends StaticBody3D
class_name store_object

@onready var objects: Node3D = $Objects
@onready var object_places: Node3D = $ObjectPlaces

var itemsPlaced = []

func _ready() -> void:
	for i in object_places.get_child_count():
		itemsPlaced.append(null)
		
func add_object(object):
	if not itemsPlaced.has(null): return false
	
	object.reparent(objects)
	
	for i in len(itemsPlaced):
		if itemsPlaced[i]: continue

		object.global_position = object_places.get_children()[i].global_position
		itemsPlaced[i] = object
		break

	object.rotation_degrees = Vector3(90,0,0)
	return true
	
func _on_objects_child_exiting_tree(node: Node) -> void:
	var index = itemsPlaced.find(node)
	itemsPlaced[index] = null
