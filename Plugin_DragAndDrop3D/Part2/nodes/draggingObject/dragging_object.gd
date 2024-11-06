@tool
extends Node3D
class_name DraggingObject3D

signal object_body_mouse_down()
signal is_dragging(boolean: bool)

@export var heightOffset := 0.0

var objectBody: PhysicsBody3D

func _ready() -> void:
	if not Engine.is_editor_hint(): 
		DragAndDropGroupHelper.group_added.connect(_on_drag_and_drop_3d_added)
	
	child_entered_tree.connect(_on_dragging_object_child_entered_tree)
	child_exiting_tree.connect(_on_dragging_object_child_exiting_tree)
	
	objectBody = _get_object_body()
	
	if objectBody: _set_object_signals()
	
	_set_group()

func _on_drag_and_drop_3d_added(group,node):
	if group == "DragAndDrop3D": node.isDragging.connect(_is_dragging)

func _is_dragging(boolean, node):
	if node == self: is_dragging.emit(boolean)

func _set_group():
	if not Engine.is_editor_hint(): 
		await get_tree().current_scene.ready
		DragAndDropGroupHelper.add_node_to_group(self, "draggingObjects")

func _get_object_body() -> PhysicsBody3D:
	for node in get_children():
		if node is PhysicsBody3D: return node
	
	return null
	
func _set_object_signals():
	objectBody.input_event.connect(_on_object_body_3d_input_event)

func _on_object_body_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		var button = event.button_index
		var isPressed = event.pressed
		
		if button == 1 and isPressed:
			object_body_mouse_down.emit()

func get_rid():
	return objectBody.get_rid()

func get_height_offset():
	return heightOffset
	
#Editor Settings
func _on_dragging_object_child_entered_tree(node: Node):
	if objectBody: return
	
	if node is PhysicsBody3D: objectBody = node
	update_configuration_warnings()
	
func _on_dragging_object_child_exiting_tree(node: Node):
	if node == objectBody: 
		objectBody = null
		update_configuration_warnings()

func _get_configuration_warnings():
	if objectBody is not PhysicsBody3D:
		return ["This node has no body, so you can't interact with it\n\nConsider adding a StaticBody3D, CharacterBody3D or RigigBody3D as a child to difine its body"]
	else:
		return []
