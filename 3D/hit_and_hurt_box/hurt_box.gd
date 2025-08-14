extends Area3D

@onready var damage_indicator: Node3D = $damageIndicator

@export var health:= 50

func take_damage(damage: int):
	damage_indicator.create_indicator_label(-damage)
	
	health -= damage
	health = clamp(health, 0, 50)
	
