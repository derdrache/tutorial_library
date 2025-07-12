extends CharacterBody2D

@export var monsterResource: MonsterResource

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var monster_status: Control = %MonsterStatus

func _ready() -> void:
	_set_model()
	
func _set_model():
	sprite_2d.texture = monsterResource.monsterEvole1Model
