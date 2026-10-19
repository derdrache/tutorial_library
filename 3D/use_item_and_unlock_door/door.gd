extends Node3D
class_name Door

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

var isOpen = false

func interaction():
	if isOpen:
		return
		
	isOpen = true
	animation_player.play("open")
	collision_shape_3d.disabled = true

func is_close():
	return not isOpen
