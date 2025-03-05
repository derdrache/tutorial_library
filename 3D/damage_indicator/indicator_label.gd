extends Node3D

func set_value(value: int):
	$SubViewport/Label.text = str(value)
	$SubViewport/Label.add_theme_color_override("font_color", _get_indicator_color(value))

func _get_indicator_color(value):
	if  value > 0: return Color.GREEN
	elif value < 0: return Color.RED
	else: return Color.GRAY
