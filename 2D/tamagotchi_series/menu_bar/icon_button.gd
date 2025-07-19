@tool
extends PanelContainer

signal pressed()

@export var icon: CompressedTexture2D:
	set(value):
		icon = value
		%TextureRect.texture = value

@onready var texture_rect: TextureRect = %TextureRect
@onready var button: Button = %Button

func _ready() -> void:
	button.pressed.connect(pressed.emit)
	button.focus_entered.connect(_set_focus.bind(true))
	button.focus_exited.connect(_set_focus.bind(false))

func _set_focus(boolean):
	var styleBox:StyleBoxFlat = get_theme_stylebox("panel")
	if boolean:
		styleBox.bg_color = Color(0.863, 0.942, 0.0)
	else:
		styleBox.bg_color = Color(0.6, 0.6, 0.6)
		
	add_theme_stylebox_override("panel", styleBox)
