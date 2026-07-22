extends PanelContainer

signal selected()

@export var item: Resource
@export var styleboxSelected: StyleBox
@export var styleboxUnselected: StyleBox

@onready var texture_rect: TextureRect = $TextureRect

func set_item(value):
	item = value
	
	if item:
		texture_rect.texture = item.texture
	else:
		texture_rect.texture = null

func get_item():
	return item

func _on_focus_entered() -> void:
	add_theme_stylebox_override("panel", styleboxSelected)
	selected.emit()

func _on_focus_exited() -> void:
	add_theme_stylebox_override("panel", styleboxUnselected)
