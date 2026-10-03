extends Area2D

@export var loot: Item

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	sprite_2d.texture = loot.icon
