extends CharacterBody2D
class_name Monster

@export var monsterResource: MonsterResource

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var status_bar: Control = $StatusBar

func _ready() -> void:
	_set_model()
	
func _set_model():
	sprite_2d.texture = monsterResource.monsterEvole1Model

func use_item(item:Item):
	if item.happiness > 0: 
		status_bar.change_happiness(item.happiness)
	elif item.hunger > 0:
		status_bar.change_hunger(item.hunger)
