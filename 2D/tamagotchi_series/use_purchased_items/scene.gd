extends Node2D

@onready var main_ui: Control = $CanvasLayer/MainUi

const ITEM = preload("res://tamagotchi/item.tscn")
const EGG = preload("res://tamagotchi/egg.tscn")
const MONSTER = preload("res://tamagotchi/monster.tscn")

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

func _on_main_ui_monster_changed() -> void:
	var newMonster = GameManager.activeMonster
	var centerPosition = Vector2(300, 160)
	
	_remove_old_monster()
	
	var monsterNode
	
	if newMonster.currentEvolve == 0:
		monsterNode = EGG.instantiate()
	else:
		monsterNode = MONSTER.instantiate()
		
	monsterNode.monsterResource = newMonster
	
	add_child(monsterNode)
	
	monsterNode.global_position = centerPosition

func _remove_old_monster():
	for child in get_children():
		if child.name == "Egg" or child.name == "Monster":
			child.queue_free()
			
			
			
			
			
			
