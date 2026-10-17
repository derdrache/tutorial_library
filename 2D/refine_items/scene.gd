extends Node2D

const ITEM = preload("uid://38eckqclycy8")

var dragItem: Node2D

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("leftClick"):
		_mouse_interaction()

func _mouse_interaction():
	var selectedObject = _get_object_on_mouse_position()
	
	if not selectedObject:
		dragItem = null
		return

	if selectedObject.is_in_group("machine"):
		_machine_interaction(selectedObject)
	else:
		dragItem = selectedObject

func _get_object_on_mouse_position():
	var mousePosition = get_global_mouse_position()
	
	var query = PhysicsPointQueryParameters2D.new()
	query.position = mousePosition
	
	if dragItem:
		query.exclude = [dragItem]
	
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_point(query)
	
	if result:
		return result[0].collider

func _machine_interaction(selectedObject):
	if dragItem:
		var canUse = selectedObject.can_use(dragItem.item)
		
		if canUse:
			selectedObject.put_usable_item(dragItem.item)
			dragItem.queue_free()
	else:
		var getMachineItem = selectedObject.get_production_item()
		
		if not getMachineItem:
			return
		
		var itemScene = ITEM.instantiate()
		itemScene.item = getMachineItem
		get_tree().current_scene.add_child(itemScene)
		
		dragItem = itemScene

func _physics_process(_delta: float) -> void:
	if dragItem:
		dragItem.global_position = get_global_mouse_position()
