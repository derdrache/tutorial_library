extends Node

signal quest_changed()
signal item_gathered(item: ITEM)
signal person_talked(person: PERSON)
signal item_received(item: Quest_System_Item)

enum QUEST_TYPE {GATHER, TALK_WITH}
enum PERSON {BEN, ANNA}
enum ITEM {EGG, FLOWER, GOLD}

var activeQuests: Array[Quest] = []
var inventory: Array[Quest_System_Item]

func add_quest(quest:Quest):
	activeQuests.append(quest.duplicate())
	quest_changed.emit()

func gather_item(item: ITEM, quantity):	
	for quest: Quest in activeQuests:
		if quest.questType == QUEST_TYPE.GATHER and quest.questItem == item:
			quest.quantityCollected += quantity
			
	quest_changed.emit()
	item_gathered.emit()

func talk_with(person: PERSON):
	for quest: Quest in activeQuests:
		if quest.questType == QUEST_TYPE.TALK_WITH and quest.questPerson == person:
			quest.quantityCollected += 1
	
	quest_changed.emit()
	person_talked.emit()

func own_quest_done(person:PERSON):
	for quest: Quest in activeQuests:
		var questDone =  quest.quantityCollected >= quest.quantityGoal
		
		if quest.to == person and questDone:
			return quest

func quest_done(quest:Quest):
	activeQuests.erase(quest)
	quest_changed.emit()
	
	var questReward = quest.questReward
	inventory.append(questReward)
	
	item_received.emit(questReward)
