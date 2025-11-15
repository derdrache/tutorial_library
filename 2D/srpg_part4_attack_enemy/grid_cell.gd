extends PanelContainer

var isSelectable = false

func highlight_cell():
	var styleBox := get_theme_stylebox("panel").duplicate()
	styleBox.bg_color = Color(1,1,0,0.5)
	add_theme_stylebox_override("panel",styleBox)

func select_cell():
	isSelectable = true
	
	var styleBox := get_theme_stylebox("panel").duplicate()
	styleBox.bg_color = Color(1,1,1, 0.5)
	add_theme_stylebox_override("panel",styleBox)

func deselect_cell():
	isSelectable = false
	
	var styleBox := get_theme_stylebox("panel").duplicate()
	styleBox.bg_color = Color(0.5,0.5,0.5, 0.5)
	add_theme_stylebox_override("panel",styleBox)	

func get_center_position():
	return global_position + size / 2
