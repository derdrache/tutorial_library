@tool
extends Node3D

@export var option: Option_Types:
	set(value):
		option = value
		notify_property_list_changed()
@export var option1Speed := 1
@export var option2List := ["How", "you", "like", "it ?"]
@export var option3Bool := false

enum Option_Types {OPTION1, OPTION2, OPTION3}

func _validate_property(property: Dictionary) -> void:
	var hideList = []
	
	match option:
		Option_Types.OPTION1:
			hideList.append("option2List")
			hideList.append("option3Bool")
		Option_Types.OPTION2:
			hideList.append("option1Speed")
			hideList.append("option3Bool")
		Option_Types.OPTION3: 
			hideList.append("option1Speed")
			hideList.append("option2List")
		
	if property.name in hideList: 
		property.usage = PROPERTY_USAGE_NO_EDITOR
