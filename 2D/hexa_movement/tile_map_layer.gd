extends TileMapLayer

func _ready() -> void:
	return
	for cell in get_used_cells():
		var label = Label.new()
		label.text = str(cell.x) + "," + str(cell.y)
		label.add_theme_font_size_override("font_size",10)
		add_child(label)
		label.global_position = map_to_local(cell) + (Vector2(-10,-10))
