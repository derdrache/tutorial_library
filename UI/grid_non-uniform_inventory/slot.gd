extends PanelContainer

@export var isEmpty := true:
	set(value):
		isEmpty = value
		
		_set_background_color()

@export var isSelected := false:
	set(value):
		isSelected = value
		
		_set_background_color(value)

func _ready() -> void:
	add_to_group("ui_slot")
	
	_set_background_color()
	
func _set_background_color(selected = false):
	var style_box := get_theme_stylebox("panel")
	var newColor : Color
	
	if selected:
		if isEmpty:
			newColor = Color.GREEN
		else:
			newColor = Color.RED
	elif isEmpty:
		newColor = Color.GRAY
	else:
		newColor = Color.BLUE
		
	newColor.a = 0.1
	style_box.bg_color = newColor
