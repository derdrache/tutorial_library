extends CharacterBody3D

@export var movement := 3

func _ready() -> void:
	add_to_group("player_character")
