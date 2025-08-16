extends Control

signal item_added(item: Item)
signal monster_changed()

@onready var menu_buttons_bar: MarginContainer = %menu_buttons_bar
@onready var menu_bar: MarginContainer = %menu_bar
@onready var item_button_bar: HBoxContainer = %item_button_bar

const ICON_BUTTON = preload("res://tamagotchi/main_ui/icon_button.tscn")

var itemDict = {
	"food": GameManager.foodItems,
	"toy": GameManager.toyItems
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
		iconButtonNode.pressed.connect(_on_item_selected.bind(item))
		if item is MonsterResource:
			iconButtonNode.icon = item.get_current_monster()
		else:
			iconButtonNode.icon = item.texture
		item_button_bar.add_child(iconButtonNode)

func _on_item_selected(item):
	_close_menu_bar()
	
	if item is MonsterResource:
		GameManager.change_monster(item)
		monster_changed.emit()
	else:
		item_added.emit(item)


func _on_monster_button_pressed() -> void:
	var monsterList = GameManager.monsterList.duplicate()
	monsterList.erase(GameManager.activeMonster)
	
	_change_menu_bar(monsterList)
	
	
	
	
	
