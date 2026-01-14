extends PanelContainer

@onready var texture_rect: TextureRect = %TextureRect
@onready var label: Label = %Label

func _ready() -> void:
	hide()
	
	GameManager.item_received.connect(_ob_item_received)

func _ob_item_received(itemBundle: ItemBundle):
	show()
	
	label.text = str(itemBundle.quantity) + "x " + itemBundle.item.name + " received"
	texture_rect.texture = itemBundle.item.texture
	
	await get_tree().create_timer(1).timeout
	
	hide()
