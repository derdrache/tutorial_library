extends Control

@onready var menu_buttons_bar: MarginContainer = %menu_buttons_bar
@onready var menu_bar: MarginContainer = %menu_bar
@onready var item_button_bar: MarginContainer = %item_button_bar

const ICON_BUTTON = preload("res://main_ui/icon_button.tscn")

var itemDict = {
	"food": [preload("res://tamagotchi_assets/banana.png")],
	"toy": [preload("res://tamagotchi_assets/ballon.png")]
}
var selectedItems: Array

func _ready() -> void:
	menu_bar.hide()

func _on_food_button_pressed() -> void:
	_change_menu_bar(itemDict["food"])

func _on_play_button_pressed() -> void:
	_change_menu_bar(itemDict["toy"])

func _change_menu_bar(items):
	if selectedItems == items:
		_close_menu_bar()
	else:
		selectedItems = items
		
		_set_menu_bar_buttons()

func _close_menu_bar():
	selectedItems = []
	menu_bar.hide()

func _set_menu_bar_buttons():
	menu_bar.show()
	
	for child in item_button_bar.get_children():
		child.queue_free()
	
	for item in selectedItems:
		var iconButtonNode = ICON_BUTTON.instantiate()
		iconButtonNode.pressed.connect(_on_item_selected)
		iconButtonNode.icon = item
		item_button_bar.add_child(iconButtonNode)

func _on_item_selected():
	_close_menu_bar()
	# continue in the next episode
