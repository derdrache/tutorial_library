extends ProgressBar

func _on_value_changed(value: float) -> void:
	_change_color(value)
	
func _change_color(value):
	var color: Color = Color.GREEN
	
	if value <= 25:
		color = Color.RED
	elif value <= 75:
		color = Color.YELLOW
		
	get("theme_override_styles/fill").bg_color = color
