extends Control

signal pressed(title)

@export var title: String

func _ready() -> void:
	add_to_group("map_way_points")
	tooltip_text = "test"

func _make_custom_tooltip(_for_text) -> Object:
	var theme = Theme.new()
	theme.set_stylebox("panel", "TooltipPanel", StyleBoxEmpty.new())
	set_theme(theme)
	
	#var newLabel = preload("res://customLabel.tscn").instantiate()
	var newLabel = Label.new()
	newLabel.text = title
	newLabel.add_theme_color_override("font_color", Color(0,0,0))
	
	return newLabel

func _on_button_pressed() -> void:
	pressed.emit(title)
