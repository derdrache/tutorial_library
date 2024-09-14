@tool
extends Area2D

@export var ropeTexture: CompressedTexture2D:
	set(newValue):
		ropeTexture = newValue

@export var length = 1:
	set(newValue):
		if newValue < 0: return
		
		length = newValue
		
		_delete_all_sprite_nodes()
		_create_rope()

@onready var collision_shape_2d = $CollisionShape2D

func _ready():
	_set_collision()

func _delete_all_sprite_nodes():
	for child in get_children():
		if child is Sprite2D: child. queue_free()
		
func _create_rope():
	for i in length:
		var ropeNode = Sprite2D.new()
		ropeNode.texture = ropeTexture
		
		add_child(ropeNode)
		ropeNode.position.y = i * 16
		
func _set_collision():
	var textureSize = ropeTexture.get_size()
	var fullLength = textureSize.y * length
	
	collision_shape_2d.shape.size.y = fullLength
	collision_shape_2d.position.y = fullLength / 2 - textureSize.y / 2
