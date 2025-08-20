extends Resource
#class_name MonsterResource

@export var eggModel: CompressedTexture2D
@export var monsterEvole1Model: CompressedTexture2D
@export var monsterEvole2Model: CompressedTexture2D
@export var monsterEvole3Model: CompressedTexture2D

@export var happiness = 100
@export var hunger = 100

@export var currentEvolve = 0

func get_current_monster():
	match currentEvolve:
		0: return eggModel
		1: return monsterEvole1Model
		2: return monsterEvole2Model
		3: return monsterEvole3Model

func get_save_data():
	return {
		"path": resource_path,
		"currentEvolve": currentEvolve,
		"happiness": happiness,
		"hunger": hunger
	}

func load_data(data):
	currentEvolve = int(data.currentEvolve)
	happiness = data.happiness
	hunger = data.hunger
