@tool
extends Control

@export var radius = 150:
	set(value):
		radius = value
		_refresh()

func _refresh(_child = null):
	var spacing = TAU / get_child_count()
	
	for child:Control in get_children():
		var index = child.get_index()
		var angle = spacing * index - PI / 2
		var targetDirection = Vector2(radius, 0).rotated(angle)
		
		child.position = targetDirection - child.size / 2

func _ready() -> void:
	child_entered_tree.connect(_refresh)
	child_exiting_tree.connect(_on_child_exiting)
	
	_refresh()

	get_child(0).grab_focus()

func _on_child_exiting(_node):
	await get_tree().process_frame
	
	_refresh()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		_select_item()
		
		
func _select_item():
	var selectedNode = get_viewport().gui_get_focus_owner()
	var selectedItem = selectedNode.itemResource
	
	# do what ever you want with the item
	
	queue_free()
	
	
	
	
	
	
	
