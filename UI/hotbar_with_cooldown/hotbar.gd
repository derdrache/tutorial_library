extends Control

@export var items : Array[Resource]

@onready var hotbar_item_container: HBoxContainer = %hotbar_item_container

const HOTBAR_ITEM = preload("res://hotbar_item.tscn")

func _ready() -> void:
	_fill_hotbar()

func _fill_hotbar():
	for item in items:
		var newHotbarIconNode = HOTBAR_ITEM.instantiate()
		newHotbarIconNode.icon = item.icon
		newHotbarIconNode.cooldownTime = item.cooldown
		hotbar_item_container.add_child(newHotbarIconNode)
