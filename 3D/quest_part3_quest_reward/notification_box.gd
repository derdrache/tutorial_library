extends PanelContainer

@onready var label: Label = $MarginContainer/Label

func _ready() -> void:
	hide()

	GameManager.item_received.connect(_on_item_received)
	
func _on_item_received(item: Quest_System_Item):
	label.text = item.name
	show()

	await get_tree().create_timer(2).timeout
	
	hide()
