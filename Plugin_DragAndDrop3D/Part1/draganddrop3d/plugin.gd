@tool
extends EditorPlugin

func _enter_tree():
	add_custom_type(
		"DragAndDrop3D", 
		"Node3D", 
		preload("res://addons/draganddrop3d/nodes/dragAndDrop3D/drag_and_drop_3d.gd"), 
		preload("dragIcon.png")
	)
	add_custom_type(
		"DraggingObject", 
		"Node", 
		preload("res://addons/draganddrop3d/nodes/draggingObject/dragging_object.gd"),
		 preload("dragIcon.png")
	)

func _exit_tree():
	remove_custom_type("DragAndDrop3D")
	remove_custom_type("DraggingObject")