extends Node

signal quest_changed()

enum QUEST_TYPE {GATHER}

var activeQuests: Array[Quest] = []

func add_quest(quest:Quest):
	activeQuests.append(quest.duplicate())
	quest_changed.emit()
