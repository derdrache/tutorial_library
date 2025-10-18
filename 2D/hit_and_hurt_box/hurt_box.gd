extends Area2D
class_name HurtBox

signal hurted()
signal died()

@export var healthPoints:= 3

func get_damage(value: int):
	healthPoints -= value
	
	hurted.emit()
	
	if healthPoints <= 0:
		died.emit()
