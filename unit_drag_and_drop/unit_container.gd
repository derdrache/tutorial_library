extends PanelContainer

@export var charScene: PackedScene
@export var icon: CompressedTexture2D

@onready var texture_rect = $TextureRect

func _ready():
	add_to_group("char")
	texture_rect.texture = icon
	
func is_on_position(position):
	return texture_rect.get_global_rect().has_point(position)
	
func get_preview():
	return texture_rect.duplicate()
