extends Resource
class_name Quest

@export_category("Quest Process")
@export var quantityCollected := 0
@export var quantityGoal := 1
@export var questType: GameManager.QUEST_TYPE
@export var questItem: GameManager.ITEM
@export var questPerson: GameManager.PERSON

@export_category("Quest Completion")
@export var to: GameManager.PERSON
@export var questReward: Quest_System_Item

@export_category("Description")
@export var name: String
@export_multiline var description: String

func get_brief_description():
	var questState = str(quantityCollected) + "/" + str(quantityGoal)
	return _get_wanted_condition_string() + " " +  _get_quest_target_string() + " " + questState 

func _get_wanted_condition_string():
	match questType:
		GameManager.QUEST_TYPE.GATHER: 
			return "Collect"
		GameManager.QUEST_TYPE.TALK_WITH: 
			return "Talk with"

func _get_quest_target_string():
	match questType:
		GameManager.QUEST_TYPE.GATHER: 
			return GameManager.ITEM.keys()[questItem].capitalize()
		GameManager.QUEST_TYPE.TALK_WITH: 
			return GameManager.PERSON.keys()[questPerson].capitalize()

func get_quest_target():
	match questType:
		GameManager.QUEST_TYPE.GATHER: 
			return questItem
		GameManager.QUEST_TYPE.TALK_WITH: 
			return questPerson
