extends Panel

var active = false:
	set(value):
		active = value
		_set_color(value)
		
func _set_color(boolean: bool):
	var styleBox := get_theme_stylebox("panel")
	
	if boolean:
		styleBox.bg_color = Color.WHITE
	else:
		styleBox.bg_color = Color.DIM_GRAY
