extends PanelContainer

@onready var slot_container: HBoxContainer = $MarginContainer/SlotContainer

var inventoryList = []

func _ready() -> void:
	inventoryList.resize(slot_container.get_child_count())

func add_item(item: Resource):
	var nextSlotNumber = _get_free_slot()
	
	if nextSlotNumber >= 0:
		inventoryList[nextSlotNumber] = item
		_refresh_ui()

func _get_free_slot():
	for i in inventoryList.size():
		if not inventoryList[i]:
			return i

func _refresh_ui():
	for i in slot_container.get_child_count():
		slot_container.get_child(i).itemResource = inventoryList[i]

func get_item_on_mouse_position():
	var mousePosition = get_global_mouse_position()
	
	for slot in slot_container.get_children():
		if slot.get_global_rect().has_point(mousePosition):
			return slot.itemResource

func remove_item(itemResource: Item):
	inventoryList.erase(itemResource)
	_refresh_ui()
