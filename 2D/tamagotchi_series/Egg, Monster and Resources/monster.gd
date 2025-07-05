extends CharacterBody2D

@export var monsterResource: MonsterResource

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	_set_model()
	
func _set_model():
	sprite_2d.texture = monsterResource.monsterEvole1Model
