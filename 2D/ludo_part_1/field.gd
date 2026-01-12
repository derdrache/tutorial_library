extends Area2D
class_name Field

@export var type: FIELD_TYPE
@export var number := -1
@export var color : GameManager.COLORS = GameManager.COLORS.NOTHING

enum FIELD_TYPE {NORMAL, HOME, GOAL, STARTPOINT}

func _ready() -> void:
	_set_group()
	
	if number < 0:
		number = get_index()

func _set_group():
	match type:
		FIELD_TYPE.HOME: add_to_group("field_home")
		FIELD_TYPE.GOAL: add_to_group("field_goal")
		FIELD_TYPE.STARTPOINT: add_to_group("field_start")

func is_free():
	return get_overlapping_areas().is_empty()

func get_pawn():
	return get_overlapping_areas()[0]
