extends Area3D

@export var health := 100

func _ready() -> void:
	add_to_group("enemy")

func do_damage(damage):
	health -= damage
	
	if health < 0: queue_free()
