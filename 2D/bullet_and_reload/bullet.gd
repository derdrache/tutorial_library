extends Area2D

@export var speed = 20

var direction: Vector2

func _physics_process(delta: float) -> void:
	global_position += direction * speed
	
