extends StaticBody2D

@export var item: Resource:
	set(value):
		item = value
		_set_item(value)

@onready var sprite_2d: Sprite2D = $Sprite2D

func _set_item(newItem: Resource):
	$Sprite2D.texture = newItem.texture.atlas
	$Sprite2D.region_rect = newItem.texture.region

func _ready() -> void:
	add_to_group("item")
	sprite_2d.region_enabled = true
	
func reset():
	sprite_2d.texture = null
