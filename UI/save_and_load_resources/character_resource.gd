extends Resource
class_name CharacterResource

@export var character_name: String
@export var level: int = 1
@export var current_exp: int = 0
@export var strength: int = 10

func load_stats():
	var saveAndLoad = SaveAndLoad.new()

	var saveFile = saveAndLoad.load_resources(saveAndLoad.SAVE_PATH, get_resource_name())

	if not saveFile: return
	
	level = saveFile.level
	current_exp = saveFile.current_exp
	strength = saveFile.strength
	
func get_resource_name() -> String:
	return resource_path.get_file()
