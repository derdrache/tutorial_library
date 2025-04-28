extends PanelContainer

@export var full = false

func change_color(color:Color):
	var styleBox := get_theme_stylebox("panel").duplicate()
	styleBox.bg_color = color
	add_theme_stylebox_override("panel",styleBox)
