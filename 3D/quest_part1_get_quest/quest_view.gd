extends Control

const QUEST_BOX = preload("uid://bewsggepnp3pf")

@onready var quest_container: VBoxContainer = %QuestContainer

func _ready() -> void:
	GameManager.quest_changed.connect(_refresh)
	
	_refresh()
	
func _refresh():
	for child in quest_container.get_children():
		child.queue_free()
		
	for quest:Quest in GameManager.activeQuests:
		var questBoxNode = QUEST_BOX.instantiate()
		questBoxNode.quest = quest
		quest_container.add_child(questBoxNode)
