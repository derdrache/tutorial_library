extends Control

signal placed_char

func _get_drag_data(at_position):
	var charNode
	
	for node in get_tree().get_nodes_in_group("char"):
		if node.is_on_position(at_position):
			charNode = node
			
	if not charNode: return
	
	var prewviewImage = charNode.get_preview()
	set_drag_preview(prewviewImage)
	
	return charNode
	
func _can_drop_data(at_position, data):
	return true
	
func _drop_data(at_position, data):
	placed_char.emit(data.charScene, at_position)
