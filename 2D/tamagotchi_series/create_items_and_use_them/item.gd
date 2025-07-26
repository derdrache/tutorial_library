extends Area2D

@export var item: Item

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	sprite_2d.texture = item.texture

func _on_body_entered(body: Node2D) -> void:
	if body is Monster:
		body.use_item(item)
		queue_free()

func set_active():
	add_to_group("PickupItem")
