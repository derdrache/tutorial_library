extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func activate():
	animated_sprite_2d.play("open")
