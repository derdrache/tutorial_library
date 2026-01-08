extends Area3D

signal hurted()
signal died()

@onready var damage_indicator: Node3D = $damageIndicator

@export var health:= 50

func take_damage(value: int):
	damage_indicator.create_indicator_label(-value)
	
	health -= value

	hurted.emit()

	if health <= 0:
		died.emit()
	
