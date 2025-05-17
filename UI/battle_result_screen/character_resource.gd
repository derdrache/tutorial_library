extends Resource
class_name CharacterResource

@export var name: String
@export var level := 1
@export var currentExp := 0
@export var talentPoints := 0

func get_exp(value):
	currentExp += value

func level_up():
	talentPoints += 1
	level += 1
	
func get_exp_for_next_level():
	return level * 35

func get_exp_for_current_level():
	return level * 35 - 35
