extends Node3D

@export var inventory: Control
@export var canvasLayer: CanvasLayer

var draggingObject: Node3D
var draggingResource: Resource
var draggingUIObject: Control

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_mouse_click"):
		_on_left_click()
	elif event is InputEventMouseMotion:
		if draggingUIObject:
			var offSet = draggingUIObject.get_minimum_size()
			draggingUIObject.global_position = get_viewport().get_mouse_position() - offSet / 2.0

func _on_left_click():
	var object = _get_mouse_object()
	var onInventory = inventory.get_rect().has_point(get_viewport().get_mouse_position())
	var useKey = draggingResource and draggingResource.itemType == Item.ITEM_TYPES.KEY
	
	if object is ItemScene and not draggingObject:
		draggingObject = object
		draggingResource = object.itemResource
		object.hide()
		_create_ui_object()
	elif onInventory and draggingObject:
		inventory.add_item(draggingResource)
	elif onInventory and not draggingObject:
		var inventoryItem = inventory.get_item_on_mouse_position()
		if inventoryItem:
			draggingResource = inventoryItem
			_create_ui_object()
	elif object is Door and useKey:
		if object.is_close():
			object.interaction()
			inventory.remove_item(draggingResource)
			_reset_dragging()
			
func _reset_dragging():
	if draggingObject:
		draggingObject.queue_free()
	draggingUIObject.queue_free()
	draggingResource = null

func _get_mouse_object():
	var mousePosition := get_viewport().get_mouse_position()
	var currentCamera := get_viewport().get_camera_3d()
	var params := PhysicsRayQueryParameters3D.new()
	
	params.from = currentCamera.project_ray_origin(mousePosition)
	params.to = currentCamera.project_position(mousePosition, 4)
	params.collide_with_areas = true
	
	var worldspace := get_world_3d().direct_space_state
	var intersect := worldspace.intersect_ray(params)
	
	if intersect:
		return intersect.collider

func _create_ui_object():
	var itemResource = draggingResource
	
	draggingUIObject = TextureRect.new()
	draggingUIObject.texture = itemResource.icon
	
	canvasLayer.add_child(draggingUIObject)
