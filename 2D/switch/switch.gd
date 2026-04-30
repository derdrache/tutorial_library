extends Node2D

@export var connectedObject:Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var isActive = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == get_tree().get_first_node_in_group("player"):
		_use_switch()

func _use_switch():
	connectedObject.activate(not isActive)
	isActive = not isActive
