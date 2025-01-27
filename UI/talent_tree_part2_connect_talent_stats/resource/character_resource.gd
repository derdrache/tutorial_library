extends Resource
class_name CharacterResource

@export var level:= 1
@export var health := 100
@export var attack := 30

@export var talents: Array[TalentResource]

func get_character_stats():
	for talent:TalentResource in talents:
		match talent.stat:
			talent.Stats.HEALTH: health += talent.statValue
			talent.Stats.ATTACK: attack += talent.statValue
	
	return {
		"level": level,
		"health": health,
		"attack": attack
	}
