extends Area2D

@export var connectedObject:Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var used := false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_use_switch()

func _use_switch():
	if used: 
		return
	
	connectedObject.activate()
	animated_sprite_2d.play("activate")
