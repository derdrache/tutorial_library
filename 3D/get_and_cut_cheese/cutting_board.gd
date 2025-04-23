extends StaticBody3D
class_name Cutting_Board

@onready var object_place: Marker3D = $ObjectPlace
@onready var label_3d: Label3D = $Label3D

var inRange = false

func add_object(object):
	object.reparent(object_place)
	object.global_position = object_place.global_position
	object.rotation_degrees = Vector3.ZERO
	_set_cut(true)

func _ready() -> void:
	label_3d.hide()

func _input(event: InputEvent) -> void:
	var hasObject = object_place.get_child_count() > 0
	
	if inRange and hasObject and Input.is_action_just_pressed("leftClick"):
		object_place.get_child(0).cut()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == get_tree().get_first_node_in_group("player"):
		inRange = true
		_set_cut(true)

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body == get_tree().get_first_node_in_group("player"):
		inRange = false
		_set_cut(false)

func _set_cut(boolean: bool):
	if object_place.get_child_count() == 0: return
	
	#label_3d.visible = boolean
