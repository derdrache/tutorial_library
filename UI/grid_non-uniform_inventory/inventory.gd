extends Control

const ITEM = preload("uid://dipxemv8cmnqb")
const SLOT_SIZE = 40

var inventory = [preload("uid://cghxdf88c4g8i"), preload("uid://bydmklcov42bd")]
var draggingItem: Control

func _ready() -> void:
	_set_inventory()
	
func _set_inventory():
	for item in inventory:
		await get_tree().process_frame
		
		var itemNode = ITEM.instantiate()
		
		add_child(itemNode)
		
		itemNode.add_child(item.itemScene.instantiate())
		
		var nextPosition = _get_next_free_position(itemNode)
		itemNode.global_position = nextPosition
		
		var effectedSlots = _get_effected_slots(nextPosition, itemNode)
		
		for slot in effectedSlots:
			slot.isEmpty = false

func _input(event: InputEvent) -> void:
	if draggingItem:
		_select_slots(event.position)

func _select_slots(at_position):
	for slot: Control in get_tree().get_nodes_in_group("ui_slot"):
		slot.isSelected = false
	
	var effectedSlots = _get_effected_slots(at_position, draggingItem)

	for slot in effectedSlots:
		slot.isSelected = true

func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		var isDragSuccessful = get_viewport().gui_is_drag_successful()
		if not isDragSuccessful:
			_reset_dragging()

func _reset_dragging():
	draggingItem.show()
	
	draggingItem = null
	
	for slot: Control in get_tree().get_nodes_in_group("ui_slot"):
		slot.isSelected = false
	
	_refresh_item_slots()

func _get_drag_data(at_position: Vector2) -> Variant:
	var selectedItem: Control
	
	for item: Control in get_tree().get_nodes_in_group("ui_item"):
		if item.get_global_rect().has_point(at_position):
			selectedItem = item

	if not selectedItem: return
	
	var preview = Control.new()
	preview.add_child(selectedItem.get_child(0).duplicate())
	set_drag_preview(preview)
	
	selectedItem.hide()
	
	draggingItem = selectedItem

	var effectedSlots = _get_effected_slots(selectedItem.global_position, selectedItem)
	
	for slot in effectedSlots:
		slot.isEmpty = true
	
	return selectedItem

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	var canDrop = true
	
	var effectedSlots = _get_effected_slots(at_position, data)
	
	var slotsNeeded = data.get_require_slots()

	if slotsNeeded != effectedSlots.size():
		canDrop = false
	
	for slot in effectedSlots:
		if not slot.isEmpty:
			canDrop = false
	
	return canDrop

func _drop_data(at_position: Vector2, data: Variant) -> void:
	var effectedSlots = _get_effected_slots(at_position, data)
			
	data.global_position = effectedSlots[0].global_position

	draggingItem.show()
	draggingItem = null

	_refresh_item_slots()

# Helper function
func _get_effected_slots(at_position, item):
	var effectedSlots = []
	var itemSize = item.get_item_grid_size()
	
	for width in itemSize.x:
		for height in itemSize.y:
			var xPosition = SLOT_SIZE * width 
			var yPosition = SLOT_SIZE * height
			var lookPosition = at_position + Vector2.ONE + Vector2(xPosition, yPosition)
			var selectedSlot = _get_slot(lookPosition)

			if selectedSlot:
				effectedSlots.append(selectedSlot)
		
	return effectedSlots

func _get_slot(at_position: Vector2):
	for slot: Control in get_tree().get_nodes_in_group("ui_slot"):
		if slot.get_global_rect().has_point(at_position):
			return slot

func _get_next_free_position(item):
	for slot in get_tree().get_nodes_in_group("ui_slot"):
		if not slot.isEmpty: continue
		
		var effectedSlots = _get_effected_slots(slot.global_position + Vector2.ONE * 2, item)
		var isPossible = true

		for effectedSlot in effectedSlots:
			if not effectedSlot.isEmpty:
				isPossible = false
		
		if isPossible:
			return slot.global_position
		else:
			continue

func _refresh_item_slots():	
	for item in get_tree().get_nodes_in_group("ui_item"):
		var itemPosition = item.global_position + Vector2.ONE * 2
		var effectedSlots = _get_effected_slots(itemPosition, item)
		
		for slot in effectedSlots:
			slot.isEmpty = false
