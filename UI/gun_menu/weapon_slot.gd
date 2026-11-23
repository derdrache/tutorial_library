extends PanelContainer

@export var selectedSyleBox : StyleBoxFlat
@export var unselectedStyleBox : StyleBoxFlat

@export var texture: CompressedTexture2D:
	set(value):
		texture = value
		%TextureRect.texture = texture
		
@onready var texture_rect: TextureRect = %TextureRect

var selected:= false:
	set(value):
		selected = value
		
		if value:
			add_theme_stylebox_override("panel", selectedSyleBox)
		else:
			add_theme_stylebox_override("panel", unselectedStyleBox)

func get_texture():
	return texture_rect.texture
