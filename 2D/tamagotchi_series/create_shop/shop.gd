extends Control

signal new_item_added(item: Item)

@onready var shop_button: TextureButton = %shopButton
@onready var shop_page: PanelContainer = %ShopPage
@onready var shop_item_grid: GridContainer = %shopItemGrid
@onready var confirm_window: PanelContainer = %ConfirmWindow

const SHOP_ITEM = preload("res://shop_item.tscn")

func _ready() -> void:
	shop_page.hide()
	confirm_window.hide()
	
	shop_button.pressed.connect(_on_shop_button_pressed)
	
	_refresh_shop_items()
	
func _refresh_shop_items():
	for child in shop_item_grid.get_children():
		child.queue_free()
	
	for item: Item in GameManager.shopItems:
		var shopItemNode = SHOP_ITEM.instantiate()
		print(item)
		shopItemNode.item = item
		shop_item_grid.add_child(shopItemNode)
		shopItemNode.pressed.connect(_on_item_selected)
		
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if shop_page.visible: shop_page.hide()

func _on_shop_button_pressed():
	shop_page.visible = not shop_page.visible

func _on_item_selected(itemResource: Item):
	confirm_window.text = "Do you really want to buy %s ?" % itemResource.itemName
	confirm_window.show()
	
	var confirm = await confirm_window.confirmed
	
	if confirm:
		_item_bought(itemResource)
		
func _item_bought(item: Item):
	GameManager.shopItems.erase(item)
	
	_refresh_shop_items()
	
	new_item_added.emit()
	
