extends PanelContainer

@onready var line_edit: LineEdit = %LineEdit

const NAMES_JSON_PATH = "res://names.json"

var nameList = []

func _ready() -> void:
	nameList = _get_name_list()

func _get_name_list():
	var file = FileAccess.open(NAMES_JSON_PATH, FileAccess.READ)
	var data = file.get_as_text()
	file.close()
	
	var json := JSON.new()
	
	return json.parse_string(data)

func _on_texture_button_pressed() -> void:
	_set_random_name()
	
func _set_random_name():
	line_edit.text = nameList.pick_random()
