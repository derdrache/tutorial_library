@tool
extends Node3D

@export var gunResource: GunResource

func _ready() -> void:
	if gunResource:
		add_child(gunResource.model.instantiate())

func get_damage_value():
	return gunResource.damage
