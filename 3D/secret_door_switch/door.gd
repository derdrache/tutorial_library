extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var isOpen = false

func interaction():
	if isOpen:
		return
		
	isOpen = true
	animation_player.play("open")
