extends Control

@onready var shoes: Sprite2D = $Player/shoes
@onready var pants: Sprite2D = $Player/pants
@onready var shirt: Sprite2D = $Player/shirt


func _on_shirt_selection_refreshed(texture: CompressedTexture2D) -> void:
	shirt.texture = texture

func _on_pant_selection_refreshed(texture: CompressedTexture2D) -> void:
	pants.texture = texture

func _on_shoes_selection_refreshed(texture: CompressedTexture2D) -> void:
	shoes.texture = texture
