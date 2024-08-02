extends Control

@onready var character_selection_box = $VBoxContainer/HBoxContainer

func _input(event):
	if event is InputEventMouseButton && event.button_index == 1 && event.is_pressed():
		var charNode = _get_char_node()
		
		if charNode: _set_char_selected(charNode)
		
		
func _get_char_node():
	var mousePos = get_viewport().get_mouse_position()
	
	for node in character_selection_box.get_children():
		if node.get_global_rect().has_point(mousePos):
			return node

func _set_char_selected(charNode):
	GlobalData.playerCharPath = charNode.characterPath
	
	for node in character_selection_box.get_children():
		var isSelected = charNode == node
		node.set_selected(isSelected)

func _on_start_button_pressed():
	if not GlobalData.playerCharPath: return
	
	get_tree().change_scene_to_file("res://top_down_scene.tscn")
