extends Node2D

signal add_raw_material(material)

func _ready() -> void:
	add_to_group("storage_house")

func add_material(material: Materials):
	add_raw_material.emit(material)
