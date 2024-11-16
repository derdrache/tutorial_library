extends MarginContainer

@export var date: Dictionary

@onready var panel_container: PanelContainer = %PanelContainer
@onready var label: Label = %Label

func _ready() -> void:
	label.text = str(date.day)
	
	_set_unselected()

func _set_unselected():
	var currentDate = Time.get_datetime_dict_from_system()
	var isCurrentDate = date.day == currentDate.day and date.month == currentDate.month and date.year == currentDate.year

	if not isCurrentDate: panel_container.add_theme_stylebox_override("panel", StyleBoxEmpty.new())	

func _on_button_pressed() -> void:
	# do what ever you want
	print(date)
