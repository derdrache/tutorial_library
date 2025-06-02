extends Node2D

@export var connectedObject:Node2D
@export var groupName: String

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var isActive = false

func _ready() -> void:
	add_to_group(groupName)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == get_tree().get_first_node_in_group("player"):
		for object in get_tree().get_nodes_in_group(groupName):
			object.use_switch()

func use_switch():
	if isActive:
		animated_sprite_2d.play_backwards("activate")
	else:
		animated_sprite_2d.play("activate")
		
	await animated_sprite_2d.animation_finished
	connectedObject.activate(not isActive)
	isActive = not isActive
