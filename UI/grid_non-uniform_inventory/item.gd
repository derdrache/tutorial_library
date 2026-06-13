extends Control

const TILE_SIZE = 16

func _ready() -> void:
	add_to_group("ui_item")
	
	child_entered_tree.connect(_on_child_entered)

func _on_child_entered(node:Node):
	size = node.region_rect.size * node.scale
	
	#adjustment to fit better in the slot
	node.position = Vector2(3,3)

func get_item_grid_size():
	return get_child(0).region_rect.size / TILE_SIZE

func get_require_slots():
	var itemSize = get_item_grid_size()
	return itemSize.x * itemSize.y
