extends Node
class_name SaveAndLoad

const BASE_PATH = "res://"
const SAVE_PATH = BASE_PATH + "save_files/"

func save_resource(path, resource, name):
	_create_dir()
		
	var fileName = resource.resource_path.get_file()
	
	ResourceSaver.save(resource, path + name + ".tres")

func _create_dir():
	var dir = DirAccess.open(BASE_PATH)
	dir.make_dir("save_files")

func load_resources(save_path, search_file_name):	
	for fileName in DirAccess.get_files_at(save_path):
		if fileName == search_file_name+".tres":
			var resource = ResourceLoader.load(save_path + fileName)
			return resource
