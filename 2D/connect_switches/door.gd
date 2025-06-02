extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func activate(boolean: bool):
	if boolean:
		animated_sprite_2d.play("open")
	else:
		animated_sprite_2d.play_backwards("open")
