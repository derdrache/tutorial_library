@tool
extends Area3D
class_name ItemScene

@export var itemResource: Resource:
	set(value):
		itemResource = value
		_change_model()

@onready var model: Node3D = $model

func _ready() -> void:
	_change_model()

func _change_model():
	if not is_node_ready():
		return
		
	if model.get_child_count() > 0:
		model.queue_free()
	
	model.add_child(itemResource.itemScene.instantiate())
