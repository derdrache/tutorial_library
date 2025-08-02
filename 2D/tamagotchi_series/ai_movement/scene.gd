extends Node2D

@onready var main_ui: Control = $CanvasLayer/MainUi

const ITEM = preload("res://tamagotchi/item.tscn")

var selectedItem

func _ready() -> void:
	main_ui.item_added.connect(_on_main_ui_item_added)
	
func _on_main_ui_item_added(item:Item):
	if selectedItem: return
	
	var itemNode = ITEM.instantiate()
	itemNode.item = item
	add_child(itemNode)
	selectedItem = itemNode

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and selectedItem:
		selectedItem.global_position = get_global_mouse_position()
	if Input.is_action_just_pressed("leftClick") and selectedItem:
		selectedItem.set_active()
		selectedItem = null
